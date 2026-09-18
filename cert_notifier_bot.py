import telebot
import mysql.connector
from datetime import datetime
import config
from io import BytesIO
from openpyxl import Workbook
from openpyxl.styles import Font, Alignment, PatternFill
import threading
import time

# Инициализация бота
bot = telebot.TeleBot(config.BOT_TOKEN)

# Подключение к БД 
def get_db_connection():
    try:
        return mysql.connector.connect(
            host=config.DB_HOST,
            user=config.DB_USER,
            password=config.DB_PASSWORD,
            database=config.DB_NAME
        )
    except Exception as e:
        print(f"[DB ERROR] {e}")
        return None

#  Генерация Excel
def generate_excel_report(user_id):
    conn = get_db_connection()
    if not conn: 
        return None
    
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT 
            e.full_name, e.position, e.email, e.phone, e.telegram_id,
            c.serial_number, c.issuer, c.subject, c.key_usage, c.valid_to, c.notes
        FROM certificates c
        JOIN employees e ON c.employee_id = e.id
        WHERE e.telegram_id = %s
        ORDER BY c.valid_to DESC
    """, (user_id,))
    results = cursor.fetchall()
    conn.close()

    if not results:
        return None

    wb = Workbook()
    ws = wb.active
    ws.title = "Мои сертификаты"

    headers = [
        "ФИО", "Должность", "Email", "Телефон", "Telegram ID",
        "Серийный номер", "Издатель", "Субъект", "Назначение ключа", 
        "Действует до", "Осталось дней", "Примечания"
    ]
    ws.append(headers)

    header_font = Font(bold=True, color="FFFFFF")
    header_fill = PatternFill(start_color="4F81BD", end_color="4F81BD", fill_type="solid")
    for col in range(1, len(headers) + 1):
        cell = ws.cell(row=1, column=col)
        cell.font = header_font
        cell.fill = header_fill
        cell.alignment = Alignment(horizontal="center")

    today = datetime.now().date()
    for row in results:
        valid_to_obj = row['valid_to']
        valid_to_date = valid_to_obj.date() if hasattr(valid_to_obj, 'date') else valid_to_obj
        days_left = (valid_to_date - today).days
        date_str = valid_to_obj.strftime('%d.%m.%Y') if hasattr(valid_to_obj, 'strftime') else str(valid_to_obj)

        ws.append([
            row['full_name'] or "",
            row['position'] or "",
            row['email'] or "",
            row['phone'] or "",
            row['telegram_id'] or "",
            row['serial_number'] or "",
            row['issuer'] or "",
            row['subject'] or "",
            row['key_usage'] or "",
            date_str,
            days_left,
            row['notes'] or ""
        ])

    for col in ws.columns:
        max_length = 0
        column_letter = col[0].column_letter
        for cell in col:
            try:
                cell_len = len(str(cell.value)) if cell.value else 0
                if cell_len > max_length:
                    max_length = cell_len
            except:
                pass
        adjusted_width = min(max_length + 2, 50)
        ws.column_dimensions[column_letter].width = adjusted_width

    output = BytesIO()
    wb.save(output)
    output.seek(0)
    return output

# Проверка прав администратора
def is_admin(user_id):
    conn = get_db_connection()
    if not conn: 
        return False
    cursor = conn.cursor()
    cursor.execute("SELECT role FROM employees WHERE telegram_id = %s", (str(user_id),))
    result = cursor.fetchone()
    conn.close()
    return result and result[0] == 'admin'

# Команда /start 
@bot.message_handler(commands=['start'])
def send_welcome(message):
    user_id = str(message.from_user.id)
    conn = get_db_connection()
    
    if not conn:
        bot.reply_to(message, "⚠️ Ошибка подключения к базе данных.")
        return

    cursor = conn.cursor()
    cursor.execute("SELECT full_name FROM employees WHERE telegram_id = %s", (user_id,))
    employee = cursor.fetchone()
    conn.close()

    if not employee:
        bot.reply_to(
            message,
            f"👋 Здравствуйте, {message.from_user.first_name}!\n\n"
            "Ваш Telegram-аккаунт <b>не найден</b> в базе сотрудников.\n\n"
            "Нажмите 📞 Поддержка для связи с поддержкой.",
            parse_mode='HTML'
        )
        return

    full_name = employee[0]
    
    keyboard = telebot.types.ReplyKeyboardMarkup(resize_keyboard=True, one_time_keyboard=False)
    keyboard.row("🔐 Мой статус", "📥 Экспорт в Excel")
    keyboard.row("📞 Поддержка")
    
    # Кнопки ТОЛЬКО для админов
    if is_admin(user_id):
        keyboard.row("⚙️ Админ-панель", "📊 Статистика")
        keyboard.row("📢 Рассылка в канал")

    bot.reply_to(
        message,
        f"👋 Привет, <b>{message.from_user.first_name}</b>!\n"
        f"Вы вошли как: <b>{full_name}</b>\n\n"
        "Выберите действие в меню:",
        reply_markup=keyboard,
        parse_mode='HTML'
    )

# Список кнопок меню 
MENU_BUTTONS = [
    "🔐 Мой статус", 
    "📥 Экспорт в Excel",
    "📞 Поддержка", 
    "⚙️ Админ-панель", 
    "📊 Статистика",
    "📢 Рассылка в канал"
]

# Обработчик МЕНЮ 
@bot.message_handler(func=lambda message: message.text in MENU_BUTTONS)
def handle_menu_buttons(message):
    text = message.text

    if text == "🔐 Мой статус":
        send_status_logic(message)
    elif text == "📥 Экспорт в Excel":
        export_excel_logic(message)
    elif text == "📞 Поддержка":
        show_contact_support(message)
    elif text == "📊 Статистика":
        send_stats_logic(message)
    elif text == "⚙️ Админ-панель":
        admin_panel_logic(message)
    elif text == "📢 Рассылка в канал":
        broadcast_button_logic(message)

#  Логика: Статус 
def send_status_logic(message):
    user_id = str(message.from_user.id)
    conn = get_db_connection()
    if not conn:
        bot.reply_to(message, "Ошибка БД")
        return

    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT c.serial_number, c.valid_to, c.notes
        FROM certificates c
        JOIN employees e ON c.employee_id = e.id
        WHERE e.telegram_id = %s
        ORDER BY c.valid_to DESC
    """, (user_id,))
    results = cursor.fetchall()
    conn.close()

    if not results:
        bot.reply_to(message, "❌ У вас нет активных сертификатов.")
        return

    response = "🔐 <b>Ваши сертификаты:</b>\n\n"
    today = datetime.now().date()
    
    for idx, row in enumerate(results, start=1):
        valid_to = row['valid_to'].date() if hasattr(row['valid_to'], 'date') else row['valid_to']
        days_left = (valid_to - today).days

        response += (
            f"{idx}. №: <code>{row['serial_number']}</code>\n"
            f"   До: {valid_to.strftime('%d.%m.%Y')} ({days_left} дн.)\n"
            f"   <b>Примечания:</b> {row['notes'] or '—'}\n\n"
        )

    bot.reply_to(message, response, parse_mode='HTML')

# Логика: Экспорт Excel 
def export_excel_logic(message):
    user_id = str(message.from_user.id)
    file = generate_excel_report(user_id)
    
    if file:
        bot.send_document(
            message.chat.id,
            document=("certificates.xlsx", file),
            caption="📎 Ваш отчет готов!",
            reply_to_message_id=message.message_id
        )
    else:
        bot.reply_to(message, "Нет данных для экспорта.")

#  Контакты поддержки 
def show_contact_support(message):
    contact_text = (
        "<b>Служба технической поддержки</b>\n\n"
        "Если у вас возникли проблемы с доступом или сертификатами, свяжитесь с нами:\n\n"
        "📞 <b>Телефон:</b> <code>+7 (495) 123-45-67</code>\n"
        "📧 <b>Email:</b> <code>ep-support@company.local</code>\n\n"
        "Режим работы: Пн-Пт, 9:00 - 18:00\n\n"
        "<b>Telegram-канал для оповещений</b>\n"
        "Ссылка: <code>https://t.me/ваша-ссылка-на-тг-бота</code>"
    )
    bot.reply_to(message, contact_text, parse_mode='HTML')

# Логика: Статистика (Админ)
def send_stats_logic(message):
    user_id = str(message.from_user.id)
    if not is_admin(user_id):
        bot.reply_to(message, "🚫 Доступ запрещен. Только для администраторов.")
        return

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    cursor.execute("SELECT COUNT(*) as total FROM certificates")
    total = cursor.fetchone()['total']
    
    cursor.execute("""
        SELECT 
            SUM(CASE WHEN valid_to >= CURDATE() THEN 1 ELSE 0 END) as active,
            SUM(CASE WHEN valid_to < CURDATE() THEN 1 ELSE 0 END) as expired
        FROM certificates
    """)
    stats = cursor.fetchone()
    
    conn.close()
    
    text = (
        f"📊 <b>Статистика системы</b>\n\n"
        f"Всего сертификатов: <b>{total}</b>\n"
        f"✅ Активных: <b>{stats['active']}</b>\n"
        f"❌ Просроченных: <b>{stats['expired']}</b>"
    )
    bot.reply_to(message, text, parse_mode='HTML')


# Логика: Админ панель 
def delete_message_after_delay(chat_id, message_id, delay=60):
    """Удаляет сообщение через указанное количество секунд"""
    def _delete():
        time.sleep(delay)
        try:
            bot.delete_message(chat_id=chat_id, message_id=message_id)
        except Exception as e:
            print(f"[WARNING] Не удалось удалить сообщение: {e}")
            # Сообщение могло быть уже удалено пользователем или у бота нет прав
    
    
    thread = threading.Thread(target=_delete, daemon=True)
    thread.start()


def admin_panel_logic(message):
    user_id = str(message.from_user.id)
    
    if not is_admin(user_id):
        bot.reply_to(message, "🚫 Доступ запрещен.")
        return
    
    text = (
        "🛡️ <b>Панель администратора</b>\n\n"
        f"🌐 <b>Ссылка:</b> <code>http://127.0.0.1:5000</code>\n"
        f"🔑 <b>Логин:</b> <tg-spoiler>{config.PANEL_LOGIN}</tg-spoiler>\n"
        f"🔒 <b>Пароль:</b> <tg-spoiler>{config.PANEL_PASSWORD}</tg-spoiler>\n\n"
        "⚠️ <i>Это сообщение удалится через 60 секунд</i>"
    )
    
    sent_message = bot.reply_to(message, text, parse_mode='HTML')
    
    # Запускаем таймер удаления (60 секунд)
    delete_message_after_delay(
        chat_id=sent_message.chat.id,
        message_id=sent_message.message_id,
        delay=10
    )

#  "Рассылка в канал" 
def broadcast_button_logic(message):
    """Показывает инструкцию по использованию рассылки"""
    if not is_admin(str(message.from_user.id)):
        bot.reply_to(message, "🚫 Доступ запрещен.")
        return
    
    instruction = (
        "📢 <b>Массовая рассылка в канал</b>\n\n"
        "Отправьте сообщение в таком формате:\n"
        "<code>/broadcast Ваше сообщение здесь</code>\n\n"
        "Пример:\n"
        "<code>/broadcast ⚠️ Завтра техработы с 02:00 до 04:00</code>\n\n"
        "💡 Поддерживается <b>HTML-разметка</b>: &lt;b&gt;жирный&lt;/b&gt;, &lt;code&gt;код&lt;/code&gt;"
    )
    bot.reply_to(message, instruction, parse_mode='HTML')

#  /broadcast 
@bot.message_handler(commands=['broadcast'])
def broadcast_command(message):
    """Отправляет сообщение в настроенный Telegram-канал"""
    user_id = str(message.from_user.id)
    
    
    if not is_admin(user_id):
        bot.reply_to(message, "🚫 Доступ запрещён. Только для администраторов.")
        return
    
    # Получаем текст сообщения после /broadcast
    try:
        text_to_send = message.text.split(maxsplit=1)[1]
    except IndexError:
        bot.reply_to(
            message,
            "📝 Использование:\n"
            "<code>/broadcast Ваше сообщение</code>\n\n"
            "Пример:\n"
            "<code>/broadcast ⚠️ Технические работы завтра</code>",
            parse_mode='HTML'
        )
        return
    
    # Отправляем в канал
    try:
        channel_id = getattr(config, 'CHANNEL_ID', None)
        if not channel_id:
            bot.reply_to(message, "❌ CHANNEL_ID не настроен в config.py")
            return
        
        sent_message = bot.send_message(
            chat_id=channel_id,
            text=text_to_send,
            parse_mode='HTML'
        )
        
        #  Подтверждение админу
        preview = text_to_send[:100] + ('...' if len(text_to_send) > 100 else '')
        confirm_text = (
            f"✅ <b>Сообщение отправлено!</b>\n\n"
            f"📬 Канал: <code>{channel_id}</code>\n"
            f"📝 Текст: {preview}"
        )
        bot.reply_to(message, confirm_text, parse_mode='HTML', disable_web_page_preview=True)
        
    except Exception as e:
        error_text = (
            f"❌ Ошибка отправки:\n<code>{str(e)}</code>\n\n"
            f"Проверьте:\n"
            f"1. CHANNEL_ID в config.py\n"
            f"2. Бот добавлен в канал как администратор"
        )
        bot.reply_to(message, error_text, parse_mode='HTML')


#  Обработчик неизвестных команд 
@bot.message_handler(func=lambda m: True)
def echo_message(message):
    if not message.text:
        return
    
    bot.reply_to(
        message, 
        "Я не понял эту команду. 😕\n\n"
        "Используйте кнопки меню."
    )

#  Запуск 
if __name__ == '__main__':
    print("Бот запущен и готов к работе...")
    try:
        bot.infinity_polling()
    except Exception as e:
        print(f"❌ Критическая ошибка: {e}")
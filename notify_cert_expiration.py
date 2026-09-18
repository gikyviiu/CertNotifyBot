import mysql.connector
import requests
from datetime import datetime, timedelta
import config

TOKEN = config.BOT_TOKEN
CHANNEL_ID = config.CHANNEL_ID

DB_CONFIG = {
    'host': config.DB_HOST,
    'user': config.DB_USER,
    'password': config.DB_PASSWORD,
    'database': config.DB_NAME
}

def log_info(message):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"[{timestamp}] {message}")

def send_telegram_message(chat_id, message):
    url = f"https://api.telegram.org/bot{TOKEN}/sendMessage"
    payload = {
        'chat_id': chat_id,
        'text': message,
        'parse_mode': 'HTML'
    }
    try:
        response = requests.post(url, data=payload)
        return response.status_code == 200
    except Exception as e:
        log_info(f"Ошибка отправки: {e}")
        return False

def notify_personal_and_channel():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor(dictionary=True)

    #  Персональные уведомления (все пользователи с telegram_id)
    cursor.execute("""
        SELECT e.telegram_id, e.full_name, c.serial_number, c.valid_to
        FROM certificates c
        JOIN employees e ON c.employee_id = e.id
        WHERE e.telegram_id IS NOT NULL
          AND c.valid_to BETWEEN %s AND %s
    """, (datetime.now(), datetime.now() + timedelta(days=7)))

    personal_msgs = {}
    for row in cursor.fetchall():
        tid = row['telegram_id']
        if tid not in personal_msgs:
            personal_msgs[tid] = []
        personal_msgs[tid].append(row)

    for tid, certs in personal_msgs.items():
        msg = "🔔 <b>Напоминание о сроке ЭП</b>\nВаши сертификаты скоро истекут:\n\n"
        for c in certs:
            days = (c['valid_to'].date() - datetime.now().date()).days
            msg += f"<code>{c['serial_number']}</code> —> {days} дн. ({c['valid_to'].strftime('%d.%m')})\n"
        send_telegram_message(tid, msg)

    #  Массовое уведомление в канал (с группировкой по сотруднику)
    cursor.execute("""
        SELECT e.full_name, e.email, c.serial_number, c.valid_to
        FROM certificates c
        JOIN employees e ON c.employee_id = e.id
        WHERE c.valid_to BETWEEN %s AND %s
        ORDER BY e.full_name, c.valid_to
    """, (datetime.now(), datetime.now() + timedelta(days=7)))

    channel_results = cursor.fetchall()
    
    if channel_results:
        # Группируем сертификаты по ФИО сотрудника
        by_employee = {}
        for r in channel_results:
            name = r['full_name']
            if name not in by_employee:
                by_employee[name] = []
            by_employee[name].append(r)
        
        # Формируем сообщение
        msg = "📢 <b>Общее уведомление</b>\nСертификаты, истекающие в ближайшие 7 дней:\n\n"
        
        for employee_name, certs in by_employee.items():
            msg += f"👤 <b>{employee_name}</b>:\n"
            for idx, c in enumerate(certs, start=1):
                days = (c['valid_to'].date() - datetime.now().date()).days
                date_str = c['valid_to'].strftime('%d.%m')
                msg += f"{idx}. Серийный №: <code>{c['serial_number']}</code> —> {days} дн. ({date_str})\n"
            msg += "\n"  # Пустая строка между сотрудниками
        
        send_telegram_message(CHANNEL_ID, msg)

    conn.close()
    log_info(f"Отправлено {len(personal_msgs)} персональных и 1 массовое уведомление")

if __name__ == "__main__":
    notify_personal_and_channel()
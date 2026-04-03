import sqlite3
import os
from datetime import datetime
from loguru import logger

class UsageLogger:
    def __init__(self, db_path="./usage.db"):
        self.db_path = db_path
        self._init_db()

    def _init_db(self):
        try:
            conn = sqlite3.connect(self.db_path)
            # Enable WAL mode
            conn.execute("PRAGMA journal_mode=WAL;")
            
            cursor = conn.cursor()
            cursor.execute("""
                CREATE TABLE IF NOT EXISTS usage_logs (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    timestamp TEXT DEFAULT (strftime('%Y-%m-%d %H:%M:%f', 'now')),
                    task_id TEXT,
                    ip_address TEXT,
                    file_name TEXT,
                    page_count INTEGER,
                    duration_sec REAL,
                    status TEXT,
                    error_msg TEXT
                )
            """)
            conn.commit()
            conn.close()
            logger.info(f"Usage database initialized at {self.db_path} (WAL mode enabled)")
        except Exception as e:
            logger.error(f"Failed to initialize usage database: {e}")

    def log_usage(self, task_id, ip_address, file_name, page_count, duration_sec, status, error_msg=None):
        try:
            conn = sqlite3.connect(self.db_path)
            cursor = conn.cursor()
            cursor.execute("""
                INSERT INTO usage_logs (task_id, ip_address, file_name, page_count, duration_sec, status, error_msg)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            """, (task_id, ip_address, file_name, page_count, duration_sec, status, error_msg))
            conn.commit()
            conn.close()
        except Exception as e:
            logger.error(f"Failed to log usage: {e}")

# Singleton instance
usage_logger = UsageLogger(os.getenv("MINERU_DB_PATH", "./usage.db"))

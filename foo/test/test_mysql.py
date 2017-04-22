import MySQLdb
import pytest

from . import retry


@pytest.fixture
def mysql()-> MySQLdb.connections.Connection:
    def f() -> MySQLdb.connections.Connection:
        db = MySQLdb.connect(
            host='mysqld', user='user',
            password='mysqlpassword', db='mydatabase')
        db.cursor()  # get real connection
        return db
    return retry(f)


def test_mysql(mysql: MySQLdb.connections.Connection) -> None:
    c: MySQLdb.cursors.Cursor = mysql.cursor()
    c.execute('SELECT id, name FROM books')
    assert c.fetchall() == ((1, 'My first book'), (2, 'barbarbar'))

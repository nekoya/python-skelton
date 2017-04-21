import time


def retry(fn):
    retry_count = 20
    for i in range(retry_count):
        try:
            return fn()
        except Exception as e:
            remain = retry_count - i
            if remain == 0:
                raise e
            time.sleep(1)

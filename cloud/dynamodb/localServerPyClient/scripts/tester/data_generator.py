import datetime
from random import randint

def get_random_dt(start, end, count):
    sdt = datetime.datetime.strptime(start, "%Y-%m-%d").timestamp()
    edt = datetime.datetime.strptime(end, "%Y-%m-%d").timestamp()

    data = [randint(sdt, edt) for i in range(0, count)]
    return data

from zoodb import *
from debug import *
from pbkdf2 import *

import hashlib
import random
import os
import bank_client

def newtoken(db, cred):
    hashinput = "%s%.10f" % (cred.password, random.random())
    cred.token = hashlib.md5(hashinput).hexdigest()
    db.commit()
    return cred.token

def login(username, password):
    db1 = person_setup()
    db2 = cred_setup()
    person = db1.query(Person).get(username)
    if not person:
        return None
    cred = db2.query(Cred).get(username)
    hashed_pw = PBKDF2(password, cred.salt).hexread(32)
    if cred.password == hashed_pw:
        return newtoken(db2, cred)
    else:
        return None

def register(username, password):
    db1 = person_setup()
    db2 = cred_setup()

    person = db1.query(Person).get(username)
    if person:
        return None
    newperson = Person()
    newcred = Cred()

    newperson.username = username
    newcred.username = username

    salt_uusi = os.urandom(128)
    newcred.password = PBKDF2(password, salt_uusi).hexread(32)
    newcred.salt = salt_uusi

    db1.add(newperson)
    db1.commit()

    db2.add(newcred)
    db2.commit()

    bank_client.create_new_bank(username, 10)

    return newtoken(db2, newcred)

def check_token(username, token):
    db1 = person_setup()
    db2 = cred_setup()
    person = db1.query(Person).get(username)
    cred = db2.query(Cred).get(username)
    if person and cred.token == token:
        return True
    else:
        return False


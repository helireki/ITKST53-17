from zoodb import *
from debug import *

import auth_client

import time

def transfer(sender, recipient, zoobars, token):
    persondb = person_setup()
    senderp = persondb.query(Person).get(sender)
    recipientp = persondb.query(Person).get(recipient)

    if not auth_client.check_token(sender, token):
        raise ValueError()

    bankdb = bank_setup()
    senderb = bankdb.query(Bank).get(sender)

    sender_balance = senderb.zoobars - zoobars

    recipientb = bankdb.query(Bank).get(recipient)

    recipient_balance = recipientb.zoobars + zoobars

    if sender_balance < 0 or recipient_balance < 0:
        raise ValueError()

    senderb.zoobars = sender_balance
    recipientb.zoobars = recipient_balance
    #persondb.commit()
    bankdb.commit()

    transfer = Transfer()
    transfer.sender = sender
    transfer.recipient = recipient
    transfer.amount = zoobars
    transfer.time = time.asctime()

    transferdb = transfer_setup()
    transferdb.add(transfer)
    transferdb.commit()

def balance(username):
    db = person_setup()
    person = db.query(Person).get(username)

    db2 = bank_setup()
    userb = db2.query(Bank).get(username)
    return userb.zoobars

def get_log(username):
    db = transfer_setup()
    return db.query(Transfer).filter(or_(Transfer.sender==username,
                                         Transfer.recipient==username))

def create_new_bank(username, zoobars):
    db = bank_setup()
    newbank = Bank()

    newbank.username = username
    newbank.zoobars = zoobars
    db.add(newbank)
    db.commit()

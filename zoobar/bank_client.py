from debug import *
from zoodb import *
import rpclib

def transfer(sender, recipient, zoobars, token):
    with rpclib.client_connect('/banksvc/sock') as c:
        ret = c.call('transfer', sender=sender, recipient=recipient, zoobars=zoobars, token=token)
        return ret

def balance(username):
    with rpclib.client_connect('/banksvc/sock') as c:
        ret = c.call('balance', username=username)
        return ret

def create_new_bank(username, zoobars):
    with rpclib.client_connect('/banksvc/sock') as c:
        ret = c.call('create_new_bank', username=username, zoobars=zoobars)
        return ret

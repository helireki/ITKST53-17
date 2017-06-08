#!/usr/bin/python
#
# Insert bank server code here.
#
import rpclib
import sys
import bank
from debug import *

class BankRpcServer(rpclib.RpcServer):
    def rpc_transfer(self, sender, recipient, zoobars, token):
        ret = bank.transfer(sender, recipient, zoobars, token)
        return ret

    def rpc_balance(self, username):
        ret = bank.balance(username)
        return ret

    def rpc_create_new_bank(self, username, zoobars):
        ret = bank.create_new_bank(username, zoobars)
        return ret

(_, dummy_zookld_fd, sockpath) = sys.argv

s = BankRpcServer()
s.run_sockpath_fork(sockpath)

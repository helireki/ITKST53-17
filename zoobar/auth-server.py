#!/usr/bin/python

import rpclib
import sys
import auth
from debug import *

class AuthRpcServer(rpclib.RpcServer):
    ## Fill in RPC methods here.
    #pass
    def rpc_login(self, username, password):
        ret = auth.login(username, password)
        return ret

    def rpc_register(self, username, password):
        ret = auth.register(username, password)
        return ret

    def rpc_check_token(self, username, token):
        ret = auth.check_token(username, token)
        return ret

    def rpc_get_token(self, username):
        ret = auth.get_token(username)
        return ret

(_, dummy_zookld_fd, sockpath) = sys.argv

s = AuthRpcServer()
s.run_sockpath_fork(sockpath)

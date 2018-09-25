function ClientNetworkSession:send_to_host(...)
	if self._server_peer then
		self._server_peer:send(FakeSyncFix(1, ...))
	end
end
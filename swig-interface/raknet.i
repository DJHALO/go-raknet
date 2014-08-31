%module raknet
%{
#include "../Source/Export.h"
#include "../Source/PluginInterface2.h"
#include "../Source/RakNetSocket2.h"
#include "../Source/RakNetTypes.h"
#include "../Source/RakPeerInterface.h"
#include "../Source/RakPeer.h"
#include "../Source/UDPProxyServer.h"
#include "../Source/UDPProxyCoordinator.h"
typedef RakNet::BitSize_t BitSize_t;
%}

namespace RakNet {
	class RakString;
	class UDPForwarder;
	struct SystemAddress;
	struct RakNetGUID;
}

#define _WIN32
#define _RAKNET_SUPPORT_UDPProxyCoordinator 1 
#define _RAKNET_SUPPORT_UDPProxyServer 1
#define _RAKNET_SUPPORT_UDPForwarder 1
%import "../Source/Export.h"
%import "../Source/PluginInterface2.h"
%import "../Source/RakNetSocket2.h"
%include "../Source/RakNetTypes.h"
%include "../Source/RakPeerInterface.h"
%include "../Source/RakPeer.h"
%include "../Source/UDPProxyServer.h"
%include "../Source/UDPProxyCoordinator.h"


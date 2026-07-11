package mage.server;

/**
 * Server: possible reasons for disconnection
 *
 * @author LevelX2, JayDi85
 */
public enum DisconnectReason {
    LostConnection(false, " has lost connection"),
    DisconnectedByUser(true, " has left Hex Nexus"),
    DisconnectedByUserButKeepTables(false, " has left Hex Nexus for app restart/reconnect"),
    DisconnectedByAdmin(true, " was disconnected by admin"),
    AnotherUserInstance(false, " disconnected by another user intance"),
    AnotherUserInstanceSilent(false, ""), // same user, no need inform in chats
    SessionExpired(true, " session expired");

    final boolean isRemoveUserTables;
    final String messageForUser;

    DisconnectReason(boolean isRemoveUserTables, String messageForUser) {
        this.isRemoveUserTables = isRemoveUserTables;
        this.messageForUser = messageForUser;
    }
}
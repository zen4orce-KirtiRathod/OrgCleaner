public class LoginHandler {
    
    public static String login(){
        String sessionId;
        String username = 'mehul.makwana@zen4orce.com';
        String password = '1122mehul';
     	string securityToken = 'zNPeIZpViuR0prT7n7yIMYLX';
    	toolingSoapSforceCom.SforceService sp = new toolingSoapSforceCom.SforceService();
        toolingSoapSforceCom.LoginResult lr = sp.login(username, password+securityToken);
        sessionId = lr.sessionId;

        return sessionId;
    }

}
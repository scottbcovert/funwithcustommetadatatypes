/**
* @author Scott Covert - Tython Co.
* @date 12/20/2015
* @description PostInstall Script
*/
public without sharing class PostInstallClass implements InstallHandler {
  /** Determines if installation is currently running */
  public static Boolean isRunningInstall = false;
  
  /**
  * @author Scott Covert - Tython Co.
  * @date 12/20/2015
  * @description Runs setup for new installations
  * @param InstallContext Contains context information regarding the current installation
  */
  public void onInstall(InstallContext context) {
    if(context.previousVersion() == null) {
        // New Installation

        // Set isRunningInstall to true
        isRunningInstall = true;

        // Retrieve installer user information from user map
        User installUser = [SELECT Id, Name, Email, Username FROM User WHERE Id = :context.installerId()];

        if (installUser!=null){
            // Send Thank You Email
            sendThankYouEmail(installUser);
        }  

    }
  }

  /**
  * @author Scott Covert - Tython Co.
  * @date 12/20/2015
  * @description Sends thank you email to a given user
  * @param User User record that should receive the thank you email
  */
  private static void sendThankYouEmail(User u) {
    String toAddress= u.Email;
    String[] toAddresses = new String[]{toAddress};
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setToAddresses(toAddresses);
    mail.setReplyTo('support@package.com');
    mail.setSenderDisplayName('Package Support');
    mail.setSubject('Installation Successful');
    mail.setPlainTextBody('Thank you for installing!');
    mail.setHtmlBody('Thank you for installing!');
    try{
        if (!Test.isRunningTest())
            Messaging.sendEmail(new Messaging.Email[] { mail });
    } catch (System.Exception e){
        // Must be a sandbox without email access
    }
  }

}
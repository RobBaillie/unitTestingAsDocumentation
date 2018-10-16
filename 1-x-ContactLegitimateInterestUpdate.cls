/**
* To update candidates and contacts legitimate interest expiry.
* Called from "Update Legitimate date from task" Process Builder
*
* @date    2018-04-03
* @author  makepositive
*
*/
public class ContactLegitimateInterestUpdate {
    
    static final String      ERROR_MESSAGE       = 'Error when attempting to update the contact legitimate expiry date';
    static final Set<String> ELIGIBLE_TASK_TYPES = new Set<String>{ 'Gold Note', 'Business Development Call', 'Open to Contact' };

    /**
     * To filter the set of Ids of Contacts and Accounts for which Legitimate Expiry needs to be updated
     *
     * @date    2018-04-03
     * @author  makepositive
     * @param   List<Id> list of task created, updated
     */
    @InvocableMethod
    public static void updateContactsLegitimateExpiryFromTask( List<Id> taskIds ) {

        Set<Id> contactIds = new Set<Id>();
    
        for( Task taskRecord : [SELECT Id, whoId, whatId
                                FROM   Task
                                WHERE  Id   IN :taskIds
                                AND    Type IN :ELIGIBLE_TASK_TYPES ] ) {

            if( taskRecord.whoId != null && taskRecord.whoId.getsObjectType() == Contact.sObjectType ) {
                contactIds.add( taskRecord.whoId );
            }
        }

        updateContactLegitimateInterestExpiryDate( contactIds );
    }

    /**
     * To update the legitimate expiry date of contacts
     *
     * @date    2018-04-03
     * @author  makepositive
     * @param   Set<Id> set of ids of contacts
     *
     */
    private static void updateContactLegitimateInterestExpiryDate( Set<Id> setOfContactIds ) {

        List<Contact> recordsToExamine = [SELECT Id, Legitimate_Interest_Expiry__c, LastActivityDate
                                          FROM   Contact
                                          WHERE  Id IN :setOfContactIds];

        List<sObject> recordsToUpdate = calculateExpiry( recordsToExamine, new List<String>{ 'Id' } );
        updateRecords( recordsToUpdate );
    }

    /**
     * Given a list of sObjects, return the most recent LI applicable activity
     * for each record in a map, indexed by the ID of the record.
     *
     * Both what and who links should be taken into account.
     *
     * @date    2018-05-18
     * @author  makepositive
     * @param   List<sObject> - The list of records  for which to get the last activity dates 
     * @param   List<String>  - The list of fields to get the Ids to use when examining the tasks
     * @return  Map<Id,Date>  - The record Ids, with the associated last activity dates
     *
     */
    private static Map<Id,Date> getLastActivityDates( List<sObject> recordsToExamine, List<String> idFields ) {

        Map<Id,Date> lastActivityDates   = new Map<Id,Date>();
        Date         oldestTaskOfConcern = System.today().addMonths( -18 );

        Set<Id>      whoIds              = new Set<Id>();

        for ( sObject thisRecord : recordsToExamine ) {

            for ( String thisIdField : idFields ) {
                whoIds.add( (Id)thisRecord.get( thisIdField ) );
            }
        }

        for ( AggregateResult thisResult : [SELECT WhoId, WhatId, MAX( LastModifiedDate ) lastDate
                                             FROM   Task
                                             WHERE  ( WhoId IN :whoIds OR WhatId IN :whoIds )
                                             AND    Type IN :ELIGIBLE_TASK_TYPES
                                             AND    LastModifiedDate > :oldestTaskOfConcern
                                             GROUP BY WhoId, WhatId ] ) {

            Id   thisWhoId  = (Id)thisResult.get( 'WhoId'  );
            Id   thisWhatId = (Id)thisResult.get( 'WhatId' );

            DateTime thisDateTime = ( (DateTime)thisResult.get( 'lastDate' ) );
            Date     thisDate     = Date.newinstance( thisDateTime.year(), thisDateTime.month(), thisDateTime.day() );

            if ( whoIds.contains( thisWhoId )
                && ( ! lastActivityDates.containsKey( thisWhoId ) )
                    || thisDate >  (Date)lastActivityDates.get( thisWhoId ) ) {

                lastActivityDates.put( thisWhoId, thisDate );
            }

            if ( whoIds.contains( thisWhatId )
                && ( ! lastActivityDates.containsKey( thisWhatId ) )
                    || thisDate >  (Date)lastActivityDates.get( thisWhatId ) ) {

                lastActivityDates.put( thisWhatId, thisDate );
            }
        }

        return lastActivityDates;
    }

    /**
     * Given a record and a list of fields to regard as Ids, will look up
     * the most recent activity date from the pre-calculated dates Map
     *
     * Is needed as activities for PersonAccounts can be against either the
     * Account or the Contact record
     *
     * @date    2018-05-18
     * @author  makepositive
     * @param   Map<Id, Date> - The last activity dates for all the objects that could be passed in
     * @param   sObject       - The record to get the date for
     * @param   List<Id>      - The list of fields to use as Ids from the record
     * @return  Date          - The most recent activity date for the record
     *
     */
    private static Date getLastActivity( Map<Id, Date> lastActivityDates, sObject thisRecord, List<String> idFields ) {

        Date lastActivity;

        for( String thisIdField : idFields ) {
            Date thisLastActivityDate = lastActivityDates.get( (Id)thisRecord.get( thisIdField ) );
            if ( thisLastActivityDate > lastActivity || lastActivity == null ) {
                lastActivity = thisLastActivityDate;
            }
        }
        return lastActivity;
    }

    /**
     * Given a list of records, will work out which need to have their expiry extended, and then
     * return a list of records to update
     *
     * @date    2018-05-18
     * @author  makepositive
     * @param   List<sObject> - The list of records to examine
     * @return  List<sObject> - The list of records to update
     *
     */
    private static List<sObject> calculateExpiry( List<sObject> recordsToExamine, List<String> idFields ) {

        List<sObject> recordsToUpdate   = new List<sObject>();
        Map<Id, Date> lastActivityDates = getLastActivityDates( recordsToExamine, idFields );

        for( sObject thisRecord : recordsToExamine ) {

            Date lastActivity = getLastActivity( lastActivityDates, thisRecord, idFields );

            if ( lastActivity != null
               && (  (Date)thisRecord.get( 'Legitimate_Interest_Expiry__c' ) < lastActivity.addMonths(18)
                  || (Date)thisRecord.get( 'Legitimate_Interest_Expiry__c' ) == null ) ) {

                thisRecord.put( 'Legitimate_Interest_Expiry__c', (Date)(lastActivity.addMonths(18)) );

                recordsToUpdate.add( thisRecord );
            } 

            if ( thisRecord.get( 'Legitimate_Interest_Expiry__c' ) == null ) {

                thisRecord.put( 'Legitimate_Interest_Expiry__c', System.Today().addMonths(1) );

                recordsToUpdate.add( thisRecord );
            }
        }

        return recordsToUpdate;
    }

    /**
     * To update the given records, and log any errors against the correct record
     *
     * @date    2018-05-18
     * @author  makepositive
     * @param   List<sObject> records to update
     */
    private static void updateRecords( List<sObject> recordsToUpdate ) {

        Map<Id,sObject> idToObjectMap = new Map<Id,sObject>( recordsToUpdate );

        List<Database.SaveResult> updateResult = new List<Database.SaveResult>();

        if( ! recordsToUpdate.isEmpty() ) {
            updateResult.addAll( Database.update( recordsToUpdate, false ) );
        }

        if( ! updateResult.isEmpty() ) {
            for( Database.SaveResult result : updateResult ){
                if( ! result.isSuccess() ) {
                    idToObjectMap.get( result.getId() ).addError( ERROR_MESSAGE );
                }
            }
        }
    }
}
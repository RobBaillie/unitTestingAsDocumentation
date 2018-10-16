@isTest
public with sharing class TaskDataFactory extends DataFactory {
	
	public TaskDataFactory() {
        super( 'Task' );
    }

    public SObject buildDefault() {
        return build( 'default' );
    }
    
    public Task build( String subject ) {
        Task task = new Task(
            Subject = subject
        );        
        return task; 
    }
    
    public Task build( String subject, Contact contact, Date activityDate ) {
        Task task = new Task(
            Subject                 = subject,
            Status                  = 'Completed',
            Priority                = 'Normal',
            WhoID                   = contact.Id,
            ActivityDate            = activityDate
        );        
        return task; 
    }

    public Task build( String subject, Contact contact, Date activityDate , String taskType ) {
        Task task = (Task)build( subject, contact, activityDate );
        task.type = taskType;
        return task; 

    }
}
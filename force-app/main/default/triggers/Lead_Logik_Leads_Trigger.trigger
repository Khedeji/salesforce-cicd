trigger Lead_Logik_Leads_Trigger on Lead (after insert, after update) {


    /***
        Ritik Raghuwanshi - 30/10/2024
        Trigger is Running when Lead is Created or Updated
        This Trigger Will Add or Delete the Logik Leads record. 
    **/
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        List<String> LeadLi = new List<String>();
        for (Lead LeadObj_Loop : Trigger.new) {
            LeadLi.add(LeadObj_Loop.Id);
        }
        system.debug('Yha hai kuch '+LeadLi);
        // borrowerQualificationLogik.analyse(LeadLi[0]);
    }
}
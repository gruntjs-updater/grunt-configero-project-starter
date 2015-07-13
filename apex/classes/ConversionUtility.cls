public with sharing class ConversionUtility {
	/**
	LEAD CONVERSION
	*/
	public static Database.LeadConvertResult convertLead(Lead lead){
		return convertLead(lead, true, null);
	}

	public static Database.LeadConvertResult convertLead(Lead lead, Boolean createOpportunity){
		return convertLead(lead, createOpportunity, lead.FirstName + ' ' +lead.LastName);
	}

	public static Database.LeadConvertResult convertLead(Lead lead, Boolean createOpportunity, String opportunityName){
		Database.Leadconvert lc = new Database.Leadconvert();
		lc.setLeadId(lead.Id);

		lc.setDoNotCreateOpportunity(createOpportunity);
		if( createOpportunity ){
			lc.setOpportunityName(opportunityName);
		}

		LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
		lc.setConvertedStatus(convertStatus.MasterLabel);
		Database.LeadConvertResult lcr = Database.convertLead(lc);
		return lcr;
	}
}
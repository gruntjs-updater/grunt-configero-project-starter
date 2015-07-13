@isTest
public class UnitTestObjectCreator {

	//Generate Data Sets
	public static void createAccountsWithOpportunities(Integer itemCount){
		createProductCatalog();
		Pricebook2 pb = getPricebook();

		Account[] accounts = new Account[]{};
		Contact[] contacts = new Contact[]{};
		Opportunity[] opportunities = new Opportunity[]{};
		Case[] cases = new Case[]{};
		for(Integer i = 0; i<itemCount; i++){
			accounts.add( createAccount() );
		}
		insert accounts;

		for(Account a : accounts){
			Contact c = createContact(a.Id);
			contacts.add(c);

			Opportunity o = createOpportunity(a.Id, pb.Id);
			opportunities.add(o);
		}
		insert contacts;
		insert opportunities;

		for(Contact c: contacts){
			Case ca = createCase(c.AccountId, c.Id);
			cases.add(ca);
		}
		insert cases;

		OpportunityLineItem[] lineItems = new OpportunityLineItem[]{};
		for(Opportunity o : opportunities){
			lineItems.addAll( createOpportunityLineItems(o.Id, itemCount) );
		}
		insert lineItems;
	}

	public static void createProductCatalog(){
		Pricebook2 pricebook = createPricebook('Super Pricebook');
		insert pricebook;

		Product2[] products = new Product2[]{};
		for(Integer i=0; i<20; i++){
			Product2 product = createProduct( getProductName() );
			products.add(product);
		}
		insert products;

		PricebookEntry[] entries = new PricebookEntry[]{};
		for(Product2 product : products){
			PricebookEntry entry = createPricebookEntry(pricebook.Id, product.Id);
			entries.add(entry);
		}
		insert entries;
	}


	//OBJECT CREATION

	public static Lead createLead(){
		return new Lead(
			FirstName = getRandomFirstName()
			, LastName = getRandomLastName()
			, Street = generateRandomStreetAddress()
			, City = getRandomCity()
			, State = getStateCode()
			, PostalCode = generateRandomZipCode()
			, Email = getEmail()
			, Phone = getPhoneNumber()
			, Company = getRandomCompanyName()
		);
	}

	public static Account createAccount(){
		return new Account(
			Phone=getPhoneNumber()
			, Name=getRandomCompanyName()
			, BillingStreet = generateRandomStreetAddress()
			, BillingCity=getRandomCity()
			, BillingState=getStateCode()
			, BillingPostalCode=generateRandomZipCode()
			, ShippingStreet = generateRandomStreetAddress()
			, ShippingCity=getRandomCity()
			, ShippingState=getStateCode()
			, ShippingPostalCode=generateRandomZipCode()
		);
	}

	public static Contact createContact(Id accountId){
		return new Contact(
			AccountId = accountId
			, Phone = getPhoneNumber()
			, Email = getEmail()
			, FirstName=getRandomFirstName()
			, LastName=getRandomLastName()
			, MailingStreet = generateRandomStreetAddress()
			, MailingCity = getRandomCity()
			, MailingState = getStateCode()
			, MailingPostalCode  = generateRandomZipCode()
			, LeadSource = 'Organic'
		);
	}

	public static Case createCase(Id accountId, Id contactId){
		return new Case(
			AccountId = accountId
			, ContactId = contactId
			, Subject = 'Please Help!'
			, Description = 'Something is broken!'
			, Origin = 'Web'
			, Priority = 'Medium'
			, Reason = 'Instructions not clear'
			, Status = 'New',
			Type = 'Question'
		);
	}

	public static Opportunity createOpportunity(Id accountId, Id pricebookId){
		return new Opportunity(
			AccountId = accountId
			, StageName = 'Requires Analysis'
			, CloseDate = Date.today().addDays(30)
			, Pricebook2Id = pricebookId
			, Type = 'New Business'
		);
	}

	private static PricebookEntry[] PRICEBOOK_ENTRIES;
	public static PricebookEntry getPricebookEntry(){
		if( PRICEBOOK_ENTRIES == null ){
			PRICEBOOK_ENTRIES =  [SELECT Id FROM PriceBookEntry WHERE isActive = true LIMIT 100];
		}
		return PRICEBOOK_ENTRIES.get(generateRandomInt(PRICEBOOK_ENTRIES.size()));
	}

	private static Pricebook2[] PRICEBOOKS;
	public static Pricebook2 getPricebook(){
		if( PRICEBOOKS == null){
			PRICEBOOKS = [SELECT Id FROM Pricebook2 WHERE isActive = true LIMIT 100];
		}
		return PRICEBOOKS.get(generateRandomInt(PRICEBOOKS.size()));
	}

	public static OpportunityLineItem createOpportunityLineItem(Id opportunityId){
		return new OpportunityLineItem(OpportunityId = opportunityId, PricebookEntryId = getPricebookEntry().Id, Quantity = generateRandomInt(100));
	}

	public static OpportunityLineItem[] createOpportunityLineItems(Id opportunityId, Integer itemCount){
		OpportunityLineItem[] lineItems = new OpportunityLineItem[]{};
		for(Integer x=0; x<itemCount; x++){
			lineItems.add( createOpportunityLineItem(opportunityId) );
		}
		return lineItems;
	}

	public static Pricebook2 createPricebook(String name){
		return new Pricebook2(Name=name, isActive=true);
	}

	public static Product2 createProduct(String name){
		return new Product2(Name = name, isActive = true);
	}

	public static PricebookEntry createPricebookEntry(Id pricebookId, Id productId){
		Integer unitPrice = generateRandomInt(9999);
		return new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productId, UnitPrice = unitPrice);
	}

	public static Attachment createAttachment(Id parentId){
		Attachment a = new Attachment();
		a.ParentId = parentId;
		a.Body = Blob.valueOf('ATTACHMENT DATA BLOB');
		a.Name = 'TestAttachment';
		return a;
	}

	//Not available in all orgs
	/*public static Quote createQuote(Id accountId, Id opportunityId){
		return new Quote(AccountId = accountId, OpportunityId = opportunityId);
	}*/

	//USER AND PROFILE
	public static User createUserWithProfile(String name, String profileName){

		Profile p = [SELECT Id FROM Profile WHERE Name=:profileName];
		
		User u = new User(
			Alias = name,
			Email='testuser@testorg.com',
			EmailEncodingKey='UTF-8', 
			LastName=name, 
			LanguageLocaleKey='en_US',
			LocaleSidKey='en_US', 
			ProfileId = p.Id,
			TimeZoneSidKey='America/New_York', 
			UserName=name+'@testorg.com'
			);
		return u;
	}

	public static User createCommunityUserWithProfile(Contact contact){
		return null;
	}

	//LEAD CONVERSION
	public static Database.LeadConvertResult convertLead(Lead lead, Boolean createOpportunity, String opportunityName){
		Database.Leadconvert lc = new Database.Leadconvert();
      lc.setLeadId(lead.Id);

      lc.setDoNotCreateOpportunity(createOpportunity);
      lc.setOpportunityName(opportunityName);

      LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
      lc.setConvertedStatus(convertStatus.MasterLabel);
      Database.LeadConvertResult lcr = Database.convertLead(lc);
      return lcr;
	}

	//UTILITY METHODS

	public static Integer generateRandomInt(Integer maxValue){
		return Math.Mod(Math.Round((Math.Random() * maxValue)),maxValue);
	}

	public static string getPhoneNumber(){
		String phoneNumber = '';
		for (Integer i = 0 ; i < 10 ; i++) {
			Integer digit = generateRandomInt(9);
			// Phone numbers cannot begin with a 0 or 1
			if (i == 0 && (digit <= 1)){
				digit = 5;
			}
			phoneNumber += '' + digit;
		}
		return phoneNumber;
	}

	private static List<String> states = new List<String> {'AL','AK','AZ','AR','CA','CO','CT','DE','DC','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY'};
	
	public static string getStateCode() {
		Integer index = generateRandomInt(states.size());
		return states[index];
	}

	private static List<String> cities = new List<String> {'Atlanta','Norcross', 'Mission Viejo', 'Portola Hills', 'Los Angeles'
		, 'Birmingham', 'Newnan', 'Moreland','West Clarkvale','Daytown','Campbury'
		,'Hilridge','Bayview','Shakerchester','Hartvale','Huntshart','Stoneplain Estates'
		,'Portburgh','Bridgewell','Cape Plumgate','Elmmill','Fairville','Glenshore'
		,'Greater Millley','Hollyhurst','Lake Harborwell','Lower Countrywood'
		,'Mapleside Terrace','Mount Oakbrook','New Whiteshore','North Riverridge'
		,'Northmount Heights','Orchard Estates','Orchardgrove Bridge','Point Glenwell'
		,'Point Lakebourne','Point Pleasanthill','Rosewood','Sheffield Farms','Sheffield Gate'
		,'Silvervale Chase','South Elmridge','Whiteville','Ashmoss','Belmont Grange'
		,'Cape Glenview','Devon Village','Downs Trails','Downstree Point','East Chase'
		,'East Countrygrove','Greater Peachmill','Mist Square','Mount Westmill','North Crossing'
		,'Northwood','Orchardbrook Manor','Orchardmill','Oxford Creek','Oxford Towers'
		,'Point Fieldcrest','Radcliffe Chase','Sea Acres','Silver Downs','Spring Acres'
		,'Westborough','Woodfair','Woodley Creek'
	};

	public static string getRandomCity() {
		Integer index = generateRandomInt(cities.size());
		return cities[index];
	}

	private static List<String> streets = new List<String> {'Elm', 'Main', 'Oak', 'Peachtree', 'Akins', 'Teasley', 'Techwood', 'Las Flores', 'Piedmont', 'North', 'Ponce De Leon', 'Bee Ridge', 'Lenox', 'Swift', 'Tuttle', 'Semoran', 'Colonial', 'Alafaya'};

	private static string getRandomStreetName() {
		Integer index = generateRandomInt(streets.size());
		return streets[index];
	}

	private static List<String> streetTypes = new List<String> {'Rd.', 'Dr.','St.', 'Lane', 'Ave', 'Circle', 'Trace', 'Trail', 'Blv'};

	private static String getRandomStreetType() {
		Integer index = generateRandomInt(streetTypes.size());
		return streetTypes[index];
	}

	public static String generateRandomStreetAddress() {
		Integer streetNumber = generateRandomInt(10000) + 1;
		return '' + streetNumber + ' ' + getRandomStreetName() + ' ' + getRandomStreetType();
	}

	private static String generateRandomZipCode(){
		String zip = '';
		for (integer i = 0 ; i < 5 ; i++) {
			Integer digit = generateRandomInt(9);
			zip += '' + digit;
		}
		return zip;
	}

	private static String[] hexCharacters = new String[]{'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};

	public static String GenerateFakeGuid(){
		String guid = '';
		for (integer i = 0 ; i < 32 ; i++) {
			if (i == 8 || i == 12 || i == 16 || i == 20){
				guid += '-';
			}
			Integer index = generateRandomInt(hexCharacters.size());
			guid += hexCharacters[index];
		}
		return guid;
	}

	private static String[] alphaNumericCharacters = new String[]{'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};

	public static string GenerateAlphaNumericString(Integer length){
		String alphaNumericString = '';

		for (integer i = 0 ; i < length ; i++) {
			Integer index = generateRandomInt(alphaNumericCharacters.size());
			alphaNumericString += alphaNumericCharacters[index];
		}

		return alphaNumericString;
	}

	public static String getRandomCompanyName() {
		String company = '';
		Integer format = generateRandomInt(7);
		if (format == 0) {
			company = getRandomLastName() + ' Configero';
		} else if (format == 1) {
			company = getRandomCity() + ' Configero';
		} else if (format == 2) {
			company = 'Configero of ' + getRandomCity();
		} else if (format == 3) {
			company = getRandomLastName() + ' and ' + getRandomLastName() + ' Consulting';
		} else if (format == 4) {
			company = getRandomCity() + ' Consulting';
		} else if (format == 5) {
			company = getRandomLastName() + ' Consulting';
		} else if (format == 6) {
			company = getRandomCity() + ' Consulting Services';
		} else if (format == 7) {
			company = getRandomFirstName() + ' ' + getRandomLastName() + ' Configero';
		}
		return company;
	}

	private static List<String> firstNames = new List<String> {'Lena','Doris','Louis','Michael','Ann','Carolyn','Faye','Peter',
		'Natasha','Roger','Joe','Fred','Dorothy','Irma','Shawn','Sheryl','Clara',
		'Frank','Jacquelyn','Louis','Jonathan','Ralph','Vincent','Emma','Bobby',
		'Gerald','Curtis','Phillip','Jeff','Paul','Linda','Candace','Juan','Genevieve',
		'Sandra','Lucille','Kirkland','Jacob','Patrick','Lawrence','Geraldine','Louis',
		'Sherri','Angie','Jeannette','Andrew','Cassandra','Claudia','Travis','Joanna',
		'Anthony','Aaron','Rodney','Chris','Todd','Vidal','Dolores','Debra','Joyce',
		'Hilda','Shelia','Christopher','Craig','Carl','Velma','David','Mike','Arthur',
		'Jeanette','Nellie','Manuel','Christina','Peter','David','Jimmy','Harry','Olga',
		'Carl','Molly','Richard','Bertha','Edward','Stephen','Janice','Harold','Ruby',
		'Eunice','Johnny','Edward','Sabrina','Hannah','Ruby','Todd','Bryan','Dolores',
		'Gregory','Samantha','Albert','Alan','Rachel','Eric','Bernice','Marvin','Justin',
		'Kenneth','Naomi','Donald','Raymond','Hannah','Andrew','Jo','Cassandra','William',
		'Joshua','David','Kenneth','Billy'
	};

	public static String getRandomFirstName(){
		Integer index = Math.Mod(generateRandomInt(firstNames.size()), firstNames.size());
		return firstNames[index];
	}

	private static List<String> lastNames = new List<String> {'Mahaffey','Kinsella','Stanfield','Tsosie','Troxell','Shilling','Land',
		'Bigler','Kastner','Gwinn','Smalls','Burroughs','Broderick','Yingling','Feder','Ha',
		'New','Floyd','Lefler','Ivey','Cardinal','Tenney','Seger','Mcginn','Mendez','Matteson',
		'Mcmaster','Frisbie','Mcelroy','Ayotte','Everson','Lunsford','Ulrich','Kujawa','Eddins',
		'Palmer','Sines','Palomo','Denison','Babbitt','Santoro','Kellerman','Fortunato',
		'Blake','Salter','Carrington','Squires','Mares','Arbogast','Mcnew','Hairston','Dowden',
		'Hadden','Pack','Martindale','Ngo','Rao','Erdman','Baltazar','Byers','Deitz','Mayle',
		'Condon','Robertson','Wilborn','Ramsey','Mckoy','Corley','Snelling','Wilford','Nevins',
		'Whitacre','Pettiford','Henning','Bidwell','Chiles','Desjardins','Stanton','Kent',
		'Vanwinkle','Bartholomew','English','Farina','Zook','Hyman','Correll','Elson','Speaks',
		'Field','Kushner','Paulin','Driggers','Clanton','Paxton','Hinojosa','Healy','Woodall',
		'Busse','Kingery','Ching','Santacruz','Tyler','Chong','Galindo','Kingston','Pelton',
		'Kyser','Eakin','Fricke','Hillard','Rolfe','Rafferty','Grow','Smart','Held'
	};

	public static String getRandomLastName(){
		Integer index = Math.Mod(generateRandomInt(lastNames.size()), lastNames.size());
		return lastNames[index];
	}

	public static String getEmail(){
		return getRandomFirstName() + '.' + getRandomLastName() + '@' + getRandomCompanyName().replace(' ','') + '.com';
	}

	private static List<String> productNames = new List<String>{'Good Package', 'Better Package', 'Best Package', 'Great Package', 'Super Package', 'Outstanding Package'};
	private static List<String> productAdverbs = new List<String>{'PLUS', 'XTRA', 'DELUXE', 'LIMITED EDITION', 'SPECIAL EDITION', '1st Edition'};
	
	public static String getProductName(){
		return productNames[generateRandomInt(productNames.size())] + ' ' + productAdverbs[generateRandomInt(productAdverbs.size())];
	}
}
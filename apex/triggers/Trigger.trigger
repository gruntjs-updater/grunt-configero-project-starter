trigger <%= triggerObjectPretty %>Trigger on <%= triggerObject %> (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
		ConfigeroTriggerFactory.createAndExecuteHandler(<%= triggerObjectPretty %>Handler.class);
}
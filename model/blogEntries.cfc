component  displayname="blogEntries" hint="the blog entries data object" output="false" persistent="true"
{
	property name="ID" fieldtype="id" unsavedvalue="0" column="blogEntriesID" generator="native" type="numeric"
	ormtype="integer" notnull="true" default="0" setter="false";
	property name="link" fieldtype="column" column="blogEntriesLink" unique="true" ormtype="string" type="string"
	length="500" notnull="true" min="10" max="500" url="";
	property name="title" fieldtype="column" column="blogEntriesTitle" ormtype="string" type="string"
	length="500" notnull="true" min="10" max="500" notempty="";
	property name="description" fieldtype="column" column="blogEntriesDescription" ormtype="string" 
	type="string"  length="4000" notnull="true" min="140" max="4000";
	property name="datePublished" fieldtype="column" column="blogEntriesDatePosted" ormtype="timestamp"
	type="date" notnull="true" date="";
	property name="dateUpdated" fieldtype="column" column="blogEntriesdateUpdated" ormtype="timestamp"
	type="date" notnull="true" date="";
	property name="isActive" fieldtype="column" column="blogEntriesIsActive" ormtype="boolean" default="true" 
	type="boolean" notnull="true" boolean="";
	/** Relationships **/
	property name="blogs" fieldtype="many-to-one" fkcolum="blogsID" cfc="blogs"
    fetch="select" lazy="true";
	
    public any function init(){
	   	return this;
    }
}
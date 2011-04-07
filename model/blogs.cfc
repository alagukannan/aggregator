component  persistent="true" displayname="blogs" hint="the blogs data object" output="false"
{
	property name="ID" fieldtype="id" unsavedvalue="0" column="blogsID" generator="native" type="numeric"
	ormtype="integer" notnull="true" default="0" setter="false";
	property name="blogURL" fieldtype="column"  column="blogsURL" uniquekey="UQ_blogurl_websiteURL" ormtype="string" 
	type="string" length="500" notnull="true" min="10" max="500" url="";
	property name="Websiteurl" fieldtype="column" column="blogsWebsiteurl" uniquekey="UQ_blogurl_websiteURL" ormtype="string" type="string"
	length="500" notnull="true" min="10" max="500" url="";
	property name="language" fieldtype="column" column="blogslanguage" ormtype="string" type="string"
	length="10" notnull="true" min="2" max="10";
	property name="title" fieldtype="column" column="blogsTitle" ormtype="string" type="string"
	length="500" notnull="true" min="10" max="500" notempty="";
	property name="description" fieldtype="column" column="blogsDescription" ormtype="string"
	type="string" length="500" notnull="true" min="10" max="500";
	property name="dateBuilt" fieldtype="column" column="blogsdateBuilt" ormtype="timestamp"
	type="date" notnull="true" date="" NotEmpty="";
	property name="dateSumitted" fieldtype="column" column="blogsdateSumitted" ormtype="timestamp"
	type="date" notnull="true" date="";
	property name="isActive" fieldtype="column" column="blogsIsActive" ormtype="boolean" default="true" 
	type="boolean" notnull="true" boolean="" NotEmpty="";
	/** not required properties **/
	property name="authorName" fieldtype="column" column="blogsAuthorname" ormtype="string" type="string"
	length="200" max="200";
	property name="authorEmail" fieldtype="column" column="blogsauthorEmail" ormtype="string" type="string"
	length="200" max="200";
	property name="authorURL" fieldtype="column" column="blogsauthorURL" ormtype="string" type="string"
	length="500" max="500";
	/** Relationships **/
	property name="Entries" fieldtype="one-to-many" cfc="blogEntries" fkcolumn="blogsID" type="array" lazy="extra" 
	fetch="select" orderby="datePublished desc" inverse="true" cascade="all-delete-orphan";
	
	
    public any function init(){
	    setdateSumitted(now());
	   	return this;
    }
	
}
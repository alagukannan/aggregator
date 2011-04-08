<cfoutput>

<h2>Frequently Asked Questions</h2>

<ul>
<li><a href="#prc.eventLink###faq1">Yet another blog aggregator?</a></li>
<li><a href="#prc.eventLink###faq2">How can I ping the aggregator?</a></li>
<li><a href="#prc.eventLink###faq3">Where can I find the source?</a></li>
<li><a href="#prc.eventLink###faq4">Can I modify the source?</a></li>
<li><a href="#prc.eventLink###faq5">Where do I report a bug?</a></li>
</ul>

<a name="faq1"></a>
<div class="answer">
<p><label>Yet Another blog aggregator?</label></p>

<p>Yes yet another aggregator but based on the awesome running on Coldbox 3.00 Framework. It was primarily developed to learn new features of coldbox like;
</p>
<ul>
	<li>Modules</li>
	<li>Wirebox</li>
	<li>baseORMService</li>
</ul>
<a href="#prc.eventLink###top">Return to Top</a>
</div>


<a name="faq2"></a>
<div class="answer">
<p><label>Can I ping the aggregator?</label></p>
<p>
Yes you can by letting your blog software to ping the below URL with blogURL query String. You can find the exact your exact blog URL in the system by
going through the <a href="#event.buildlink(linkto='#event.getCurrentModule()#/list')#">blogs list page</a>.
</p>
</p>
#event.buildlink(linkto='#event.getCurrentModule()#/ping?blogURL=')#
<br/>
The ping service would return a json string with hasError and message properties.
</p>
<a href="#prc.eventLink###top">Return to Top</a>
</div>

<a name="faq3"></a>
<div class="answer">
<p><label>Where can I find the source?</label></p>
<p>
You can find the source from <a href="http://www.coldbox.org/forgebox/view/Aggregator">Forgebox modules section</a> or from <a href="https://github.com/alagukannan/aggregator">github</a>.
</p>
<a href="#prc.eventLink###top">Return to Top</a>
</div>

<a name="faq4"></a>
<div class="answer">
<p><label>Can I modify the source?</label></p>
<p>
Yes you can. I'm not evil.
</p>
<a href="#prc.eventLink###top">Return to Top</a>
</div>

<a name="faq5"></a>
<div class="answer">
<p><label>Where do I report a bug?</label></p>
<p>
Damn there is always bugs. Currently I don't have any bug reporting system but do drop me a email @ toalakan-bugs-at-yahoo-dot-com. 
</p>
<a href="#prc.eventLink###top">Return to Top</a>
</div>
</cfoutput>
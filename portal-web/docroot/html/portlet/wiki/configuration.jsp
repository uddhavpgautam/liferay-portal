<%--
/**
 * Copyright (c) 2000-2013 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/html/portlet/wiki/init.jsp" %>

<%
String tabs2 = ParamUtil.getString(request, "tabs2", "display-settings");

String emailFromName = ParamUtil.getString(request, "preferences--emailFromName--", WikiUtil.getEmailFromName(portletPreferences, company.getCompanyId()));
String emailFromAddress = ParamUtil.getString(request, "preferences--emailFromAddress--", WikiUtil.getEmailFromAddress(portletPreferences, company.getCompanyId()));

boolean emailPageAddedEnabled = ParamUtil.getBoolean(request, "preferences--emailPageAddedEnabled--", WikiUtil.getEmailPageAddedEnabled(portletPreferences));
boolean emailPageUpdatedEnabled = ParamUtil.getBoolean(request, "preferences--emailPageUpdatedEnabled--", WikiUtil.getEmailPageUpdatedEnabled(portletPreferences));

String emailParam = StringPool.BLANK;
String defaultEmailSubject = StringPool.BLANK;
String defaultEmailBody = StringPool.BLANK;

if (tabs2.equals("page-added-email")) {
	emailParam = "emailPageAdded";
	defaultEmailSubject = ContentUtil.get(PropsValues.WIKI_EMAIL_PAGE_ADDED_SUBJECT);
	defaultEmailBody = ContentUtil.get(PropsValues.WIKI_EMAIL_PAGE_ADDED_BODY);
}
else if (tabs2.equals("page-updated-email")) {
	emailParam = "emailPageUpdated";
	defaultEmailSubject = ContentUtil.get(PropsValues.WIKI_EMAIL_PAGE_UPDATED_SUBJECT);
	defaultEmailBody = ContentUtil.get(PropsValues.WIKI_EMAIL_PAGE_UPDATED_BODY);
}

String emailSubjectParam = emailParam + "Subject";
String emailBodyParam = emailParam + "Body";

String emailSubject = PrefsParamUtil.getString(portletPreferences, request, emailSubjectParam, defaultEmailSubject);
String emailBody = PrefsParamUtil.getString(portletPreferences, request, emailBodyParam, defaultEmailBody);
%>

<liferay-portlet:actionURL portletConfiguration="true" var="configurationActionURL" />

<liferay-portlet:renderURL portletConfiguration="true" var="configurationRenderURL">
	<portlet:param name="tabs2" value="<%= tabs2 %>" />
</liferay-portlet:renderURL>

<aui:form action="<%= configurationActionURL %>" method="post" name="fm" onSubmit='<%= "event.preventDefault(); " + renderResponse.getNamespace() + "saveConfiguration();" %>'>
	<aui:input name="<%= Constants.CMD %>" type="hidden" value="<%= Constants.UPDATE %>" />
	<aui:input name="tabs2" type="hidden" value="<%= tabs2 %>" />
	<aui:input name="redirect" type="hidden" value="<%= configurationRenderURL %>" />

	<%
	String tabs2Names = "display-settings,email-from,page-added-email,page-updated-email";

	if (PortalUtil.isRSSFeedsEnabled()) {
		tabs2Names += ",rss";
	}
	%>

	<liferay-ui:tabs
		names="<%= tabs2Names %>"
		param="tabs2"
		url="<%= configurationRenderURL %>"
	/>

	<liferay-ui:error key="emailFromAddress" message="please-enter-a-valid-email-address" />
	<liferay-ui:error key="emailFromName" message="please-enter-a-valid-name" />
	<liferay-ui:error key="emailPageAddedBody" message="please-enter-a-valid-body" />
	<liferay-ui:error key="emailPageAddedSubject" message="please-enter-a-valid-subject" />
	<liferay-ui:error key="emailPageUpdatedBody" message="please-enter-a-valid-body" />
	<liferay-ui:error key="emailPageUpdatedSubject" message="please-enter-a-valid-subject" />
	<liferay-ui:error key="visibleNodesCount" message="please-specify-at-least-one-visible-node" />

	<c:choose>
		<c:when test='<%= tabs2.equals("display-settings") %>'>
			<%@ include file="/html/portlet/wiki/display_settings.jspf" %>
		</c:when>
		<c:when test='<%= tabs2.equals("email-from") %>'>
			<aui:fieldset>
				<aui:input cssClass="lfr-input-text-container" label="name" name="preferences--emailFromName--" value="<%= emailFromName %>" />

				<aui:input cssClass="lfr-input-text-container" label="address" name="preferences--emailFromAddress--" value="<%= emailFromAddress %>" />
			</aui:fieldset>

			<aui:fieldset cssClass="definition-of-terms">
				<legend>
					<liferay-ui:message key="definition-of-terms" />
				</legend>

				<dl>
					<dt>
						[$COMPANY_ID$]
					</dt>
					<dd>
						<liferay-ui:message key="the-company-id-associated-with-the-wiki" />
					</dd>
					<dt>
						[$COMPANY_MX$]
					</dt>
					<dd>
						<liferay-ui:message key="the-company-mx-associated-with-the-wiki" />
					</dd>
					<dt>
						[$COMPANY_NAME$]
					</dt>
					<dd>
						<liferay-ui:message key="the-company-name-associated-with-the-wiki" />
					</dd>
					<dt>
						[$PAGE_USER_ADDRESS$]
					</dt>
					<dd>
						<liferay-ui:message key="the-email-address-of-the-user-who-added-the-page" />
					</dd>
					<dt>
						[$PAGE_USER_NAME$]
					</dt>
					<dd>
						<liferay-ui:message key="the-user-who-added-the-page" />
					</dd>
					<dt>
						[$PORTLET_NAME$]
					</dt>
					<dd>
						<%= PortalUtil.getPortletTitle(renderResponse) %>
					</dd>
					<dt>
						[$SITE_NAME$]
					</dt>
					<dd>
						<liferay-ui:message key="the-site-name-associated-with-the-wiki" />
					</dd>
				</dl>
			</aui:fieldset>
		</c:when>
		<c:when test='<%= tabs2.startsWith("page-") %>'>
			<aui:fieldset>
				<c:choose>
					<c:when test='<%= tabs2.equals("page-added-email") %>'>
						<aui:input label="enabled" name="preferences--emailPageAddedEnabled--" type="checkbox" value="<%= emailPageAddedEnabled %>" />
					</c:when>
					<c:when test='<%= tabs2.equals("page-updated-email") %>'>
						<aui:input label="enabled" name="preferences--emailPageUpdatedEnabled--" type="checkbox" value="<%= emailPageUpdatedEnabled %>" />
					</c:when>
				</c:choose>

				<aui:input cssClass="lfr-input-text-container" label="subject" name='<%= "preferences--" + emailSubjectParam + "--" %>' value="<%= emailSubject %>" />

				<aui:input cssClass="lfr-textarea-container" label="body" name='<%= "preferences--" + emailBodyParam + "--" %>' type="textarea" value="<%= emailBody %>" />
			</aui:fieldset>

			<aui:fieldset cssClass="definition-of-terms">
				<legend>
					<liferay-ui:message key="definition-of-terms" />
				</legend>

				<dl>
					<dt>
						[$COMPANY_ID$]
					</dt>
					<dd>
						<liferay-ui:message key="the-company-id-associated-with-the-wiki" />
					</dd>
					<dt>
						[$COMPANY_MX$]
					</dt>
					<dd>
						<liferay-ui:message key="the-company-mx-associated-with-the-wiki" />
					</dd>
					<dt>
						[$COMPANY_NAME$]
					</dt>
					<dd>
						<liferay-ui:message key="the-company-name-associated-with-the-wiki" />
					</dd>
					<dt>
						[$DIFFS_URL$]
					</dt>
					<dd>
						<liferay-ui:message key="the-url-of-the-page-comparing-this-page-content-with-the-previous-version" />
					</dd>
					<dt>
						[$FROM_ADDRESS$]
					</dt>
					<dd>
						<%= HtmlUtil.escape(emailFromAddress) %>
					</dd>
					<dt>
						[$FROM_NAME$]
					</dt>
					<dd>
						<%= HtmlUtil.escape(emailFromName) %>
					</dd>
					<dt>
						[$NODE_NAME$]
					</dt>
					<dd>
						<liferay-ui:message key="the-node-in-which-the-page-was-added" />
					</dd>
					<dt>
						[$PAGE_CONTENT$]
					</dt>
					<dd>
						<liferay-ui:message key="the-page-content" />
					</dd>
					<dt>
						[$PAGE_DATE_UPDATE$]
					</dt>
					<dd>
						<liferay-ui:message key="the-date-of-the-modifications" />
					</dd>
					<dt>
						[$PAGE_DIFFS$]
					</dt>
					<dd>
						<liferay-ui:message key="the-page-content-compared-with-the-previous-version-page-content" />
					</dd>
					<dt>
						[$PAGE_ID$]
					</dt>
					<dd>
						<liferay-ui:message key="the-page-id" />
					</dd>
					<dt>
						[$PAGE_SUMMARY$]
					</dt>
					<dd>
						<liferay-ui:message key="the-summary-of-the-page-or-the-modifications" />
					</dd>
					<dt>
						[$PAGE_TITLE$]
					</dt>
					<dd>
						<liferay-ui:message key="the-page-title" />
					</dd>
					<dt>
						[$PAGE_URL$]
					</dt>
					<dd>
						<liferay-ui:message key="the-page-url" />
					</dd>
					<dt>
						[$PAGE_USER_ADDRESS$]
					</dt>
					<dd>
						<liferay-ui:message key="the-email-address-of-the-user-who-added-the-page" />
					</dd>
					<dt>
						[$PAGE_USER_NAME$]
					</dt>
					<dd>
						<liferay-ui:message key="the-user-who-added-the-page" />
					</dd>
					<dt>
						[$PORTAL_URL$]
					</dt>
					<dd>
						<%= company.getVirtualHostname() %>
					</dd>
					<dt>
						[$PORTLET_NAME$]
					</dt>
					<dd>
						<%= PortalUtil.getPortletTitle(renderResponse) %>
					</dd>
					<dt>
						[$SITE_NAME$]
					</dt>
					<dd>
						<liferay-ui:message key="the-site-name-associated-with-the-wiki" />
					</dd>
					<dt>
						[$TO_ADDRESS$]
					</dt>
					<dd>
						<liferay-ui:message key="the-address-of-the-email-recipient" />
					</dd>
					<dt>
						[$TO_NAME$]
					</dt>
					<dd>
						<liferay-ui:message key="the-name-of-the-email-recipient" />
					</dd>
				</dl>
			</aui:fieldset>
		</c:when>
		<c:when test='<%= tabs2.equals("rss") %>'>
			<liferay-ui:rss-settings
				delta="<%= rssDelta %>"
				displayStyle="<%= rssDisplayStyle %>"
				enabled="<%= enableRSS %>"
				feedType="<%= rssFeedType %>"
			/>
		</c:when>
	</c:choose>

	<aui:button-row>
		<aui:button type="submit" />
	</aui:button-row>
</aui:form>

<aui:script>
	Liferay.provide(
		window,
		'<portlet:namespace />saveConfiguration',
		function() {
			<c:if test='<%= tabs2.equals("display-settings") %>'>
				document.<portlet:namespace />fm.<portlet:namespace />visibleNodes.value = Liferay.Util.listSelect(document.<portlet:namespace />fm.<portlet:namespace />currentVisibleNodes);
				document.<portlet:namespace />fm.<portlet:namespace />hiddenNodes.value = Liferay.Util.listSelect(document.<portlet:namespace />fm.<portlet:namespace />availableVisibleNodes);
			</c:if>

			submitForm(document.<portlet:namespace />fm);
		},
		['liferay-util-list-fields']
	);
</aui:script>
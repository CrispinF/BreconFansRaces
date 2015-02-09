<%@ Control Language="VB" ClassName="ResultsArchive.ascx" Inherits="mojoPortal.Web.SiteModuleControl" %>
<%@ Import Namespace="mojoPortal.Business" %>
<%@ Import Namespace="mojoPortal.Business.WebHelpers" %>
<%@ Import Namespace="mojoPortal.Web.Framework" %>
<%@ Import Namespace="mojoPortal.Web.Controls" %>
<%@ Import Namespace="mojoPortal.Web.Editor" %>
<%@ Import Namespace="mojoPortal.Net" %>
<%@ Import Namespace="system.IO" %>

<script runat="server">
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim accessDataSourcePath As String
        accessDataSourcePath = ConfigurationManager.AppSettings("BreconFansResultsDatabasePath").ToString()
        Dim DBfile As String = Server.MapPath(accessDataSourcePath & "/RaceManager.mdb")
        'Me.AccessDataSource_Results.DataFile = accessDataSourcePath & "/RaceManager.mdb"
        'Me.AccessDataSource_Cats.DataFile = accessDataSourcePath & "/RaceManager.mdb"
        'Me.AccessDataSource_Clubs.DataFile = accessDataSourcePath & "/RaceManager.mdb"
        'Me.AccessDataSource_Years.DataFile = accessDataSourcePath & "/RaceManager.mdb"
        'Me.AccessDataSource_UsageLog.DataFile = accessDataSourcePath & "/UsageLog.mdb"
        feedback.Text = "Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=" & DBfile
        feedback.Text += If(File.Exists(DBfile), "File exists.", "File does not exist.")
    End Sub




</script>

<mp:cornerroundertop id="ctop1" runat="server" />
<asp:Panel ID="pnlWrapper" runat="server" CssClass="panelwrapper linksmodule">
    <portal:moduletitlecontrol id="Title1" runat="server" />

    <div style="padding: 0; margin: 0; width: 100%;">
        <p>Connection string:</p>
        <asp:TextBox ID="feedback" runat="server" Width="100%"></asp:TextBox>
    </div>

</asp:Panel>
<mp:cornerrounderbottom id="cbottom1" runat="server" />


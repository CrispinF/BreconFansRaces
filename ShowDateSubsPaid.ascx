<%@ Control Language="C#" ClassName="HelloMojoModule.ascx" Inherits="mojoPortal.Web.SiteModuleControl" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.Common" %>
<%@ Import Namespace="mojoPortal.Business" %>
<%@ Import Namespace="mojoPortal.Business.WebHelpers" %>
<%@ Import Namespace="mojoPortal.Web.Framework" %>
<%@ Import Namespace="mojoPortal.Web" %>
<%@ Import Namespace="mojoPortal.Web.Controls" %>
<%@ Import Namespace="mojoPortal.Web.UI" %>
<%@ Import Namespace="mojoPortal.Web.Editor" %>
<%@ Import Namespace="mojoPortal.Net" %>


<script runat="server"> 
    //private int pageNumber = 1;
    //private int pageSize = 15;
    //private int totalPages = 0;
    //private string sort = "Name";
    int rownum = 1;
    protected override void OnInit(EventArgs e)
    {
        base.OnInit(e);
    }

    protected void Page_Load(object sender, EventArgs e)
    {

        LoadSettings();

        PopulateLabels();



        if (!Page.IsPostBack)
        {
            PopulateControls();
        }

    }

    private void BindGrid()
    {

        SavedQueryRespository repository = new SavedQueryRespository();
        // we can fetch a saved query by name or guid
        SavedQuery q = repository.Fetch("DateSubsLastPaid");
        if (q == null) { return; }

        // here we pass in the sql statement from the saved query
        // the first parameter allows us to override the connection string if we want to
        using (IDataReader reader = DatabaseHelper.GetReader(string.Empty, q.Statement))
        //IDataReader reader = DatabaseHelper.GetReader(string.Empty, q.Statement);
        // cf try datatable for sorting but might not work as based on datareader
        //using (DataTable mytable = DatabaseHelper.GetTableFromDataReader(reader))
        {

            grdSubsLastPaid.DataSource = reader;
            //grdSubsLastPaid.PageIndex = pageNumber;
            //grdSubsLastPaid.PageSize = pageSize;
            grdSubsLastPaid.DataBind();
        }

    }

    private void PopulateControls()
    {
        //string pageUrl = SiteRoot
        //        + "/Admin/ManageUsers.aspx?userid=";
        // use this to bind to saved query: BindGrid();

    }


    private void PopulateLabels()
    {

    }

    private void LoadSettings()
    {

        // TODO: if your feature has an edit page link to it here
        //Title1.EditUrl = SiteRoot + "/MyClassEdit.aspx";
        //Title1.EditText = 

        Title1.Visible = !this.RenderInWebPartMode;
        if (this.ModuleConfiguration != null)
        {
            this.Title = this.ModuleConfiguration.ModuleTitle;
            this.Description = this.ModuleConfiguration.FeatureName;
        }

    }

</script>

<portal:OuterWrapperPanel ID="pnlOuterWrap" runat="server">
    <mp:CornerRounderTop ID="ctop1" runat="server" />
    <portal:InnerWrapperPanel ID="pnlInnerWrap" runat="server" CssClass="panelwrapper mymodule">
        <asp:UpdatePanel ID="upGallery" UpdateMode="Conditional" runat="server">
            <ContentTemplate>
                <portal:ModuleTitleControl ID="Title1" runat="server" />
                <portal:OuterBodyPanel ID="pnlOuterBody" runat="server">
                    <portal:InnerBodyPanel ID="pnlInnerBody" runat="server" CssClass="modulecontent">
                        <p>
                            This table shows all Mynydd Du members with their contact email address and the date they last paid subs. 
                            Click on a column heading to sort on that column. Click an email address to send a message.
                        </p>
                        <p>
                            If your email address is incorrect, please update it on <a href="/Secure/UserProfile.aspx">your account page</a>.
                            If the information about your subs is incorrect, please contact the Membership Secretary through the <a href="/contact">Contact Form</a>. 
                        </p>
                        <div class="AspNet-GridView">

                            <asp:SqlDataSource ID="SqlDataSource1" runat="server"
                                ConnectionString="<%$ AppSettings:MSSQLConnectionString %>"
                                SelectCommand="SET DATEFORMAT dmy;SELECT U.UserID, U.Name, U.email, UP.DateSubsLastPaid, CASE WHEN ISDATE(UP.DateSubsLastPaid)=1 THEN CAST(UP.DateSubsLastPaid AS Date) ELSE NULL END as SubsDate FROM mp_Users U
LEFT OUTER JOIN (SELECT UserGUID, PropertyValueString As DateSubsLastPaid FROM mp_UserProperties UP WHERE PropertyName = 'DateSubsPaid') UP
ON U.UserGUID = UP.UserGUID
WHERE U.IsLockedOut=0 ORDER BY U.Name;"></asp:SqlDataSource>
                            <asp:GridView AllowSorting="true" ID="grdSubsLastPaid" runat="server" AutoGenerateColumns="False" DataKeyNames="UserID" DataSourceID="SqlDataSource1">
                                <AlternatingRowStyle CssClass="AspNet-GridView-Alternate" />
                                <Columns>
                                    <asp:TemplateField HeaderText="Row#">
                                        <ItemTemplate>
                                            <%# rownum++ %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="Name"
                                        DataField="Name" SortExpression="Name"></asp:BoundField>
                                    <asp:TemplateField SortExpression="email" HeaderText="Email">
                                        <ItemTemplate>
                                            <asp:HyperLink runat="server" Text='<%# Eval("email") %>' NavigateUrl='<%# Eval("email", "mailto:{0}") %>' ID="Email1" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="Date Subs Last Paid"
                                        DataField="SubsDate" DataFormatString="{0:dd MMMM yyyy}"
                                        SortExpression="SubsDate"></asp:BoundField>

                                    <asp:HyperLinkField HeaderText="View/edit" Text="Click to edit" DataNavigateUrlFields="UserID" DataNavigateUrlFormatString="/Admin/ManageUsers.aspx?userid={0}" />

                                </Columns>

                            </asp:GridView>

                        </div>

                    </portal:InnerBodyPanel>
                </portal:OuterBodyPanel>
            </ContentTemplate>
        </asp:UpdatePanel>
        <portal:EmptyPanel ID="divCleared" runat="server" CssClass="cleared" SkinID="cleared"></portal:EmptyPanel>
    </portal:InnerWrapperPanel>
    <mp:CornerRounderBottom ID="cbottom1" runat="server" />
</portal:OuterWrapperPanel>

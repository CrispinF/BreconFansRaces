<%@ Control Language="VB" ClassName="ResultsArchive.ascx" Inherits="mojoPortal.Web.SiteModuleControl" %>
<%@ Import Namespace="mojoPortal.Business" %>
<%@ Import Namespace="mojoPortal.Business.WebHelpers" %>
<%@ Import Namespace="mojoPortal.Web.Framework" %>
<%@ Import Namespace="mojoPortal.Web.Controls" %>
<%@ Import Namespace="mojoPortal.Web.Editor" %>
<%@ Import Namespace="mojoPortal.Net" %>

<script runat="server">
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        SQLDataSource_Results.ConnectionString = ConfigurationManager.AppSettings("MSSQLConnectionString").ToString()
        SQLDataSource_Cats.ConnectionString = ConfigurationManager.AppSettings("MSSQLConnectionString").ToString()
        SQLDataSource_Years.ConnectionString = ConfigurationManager.AppSettings("MSSQLConnectionString").ToString()
        SQLDataSource_Clubs.ConnectionString = ConfigurationManager.AppSettings("MSSQLConnectionString").ToString()
    End Sub
    Protected Sub SaveCriteria()
        'write filter control values into session vars
        If Not String.IsNullOrEmpty(Session.Item("Race")) Then
            Session.Item("Race") = rblRacePick.Text.ToUpper
        Else
            Session.Add("Race", rblRacePick.Text.ToUpper)
        End If

        If Not String.IsNullOrEmpty(Session.Item("YearValue")) Then
            Session.Item("YearValue") = DDL_Year.Text
        Else
            Session.Add("YearValue", DDL_Year.Text)
        End If

        If Not String.IsNullOrEmpty(Session.Item("SexValue")) Then
            Session.Item("SexValue") = DDL_Sex.Text
        Else
            Session.Add("SexValue", DDL_Sex.Text)
        End If
        
        If Not String.IsNullOrEmpty(Session.Item("CatValue")) Then
            Session.Item("CatValue") = DDL_Cat.Text
        Else
            Session.Add("CatValue", DDL_Cat.Text)
        End If
        
        If Not String.IsNullOrEmpty(Session.Item("ClubValue")) Then
            Session.Item("ClubValue") = DDL_Club.Text
        Else
            Session.Add("ClubValue", DDL_Club.Text)
        End If
        
        If Not String.IsNullOrEmpty(Session.Item("NameValue")) Then
            Session.Item("NameValue") = Txt_Name.Text
        Else
            Session.Add("NameValue", Txt_Name.Text)
        End If
        
    End Sub
    Protected Sub rblRacePick_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles rblRacePick.PreRender
        If Not String.IsNullOrEmpty(Request.QueryString("race")) Then
            If Request.QueryString("race") = "PEN Y FAN" Then
                rblRacePick.Items(0).Selected = True
                rblRacePick.Items(1).Selected = False
            Else
                rblRacePick.Items(0).Selected = False
                rblRacePick.Items(1).Selected = True
            End If

        Else
            'DDL_Year.Text = "ALL"
        End If

    End Sub

    Protected Sub DDL_Year_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles DDL_Year.PreRender
        If Not Page.IsPostBack Then
            If Not String.IsNullOrEmpty(Request.QueryString("year")) Then
                Try ' may fail if the stored year does not exist for the selected race
                    DDL_Year.Text = Request.QueryString("year")
                Catch
                    'DDL_Year.Text = "ALL"
                End Try
            Else
                ' page opened without year param so fetch latest year (i.e. do not fetch every record)
                ' the 0th item should be "ALL" and the 1st item should be the latest year of results
                DDL_Year.Text = DDL_Year.Items(1).Text '"ALL"
            End If
        End If
    End Sub


    Protected Sub DDL_Sex_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles DDL_Sex.PreRender
        If Not Page.IsPostBack Then
            If Not String.IsNullOrEmpty(Request.QueryString("sex")) Then
                DDL_Sex.Text = Request.QueryString("sex")
            Else
                DDL_Sex.Text = "ALL"
            End If
        End If
    End Sub


    Protected Sub DDL_Club_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles DDL_Club.PreRender
        If Not Page.IsPostBack Then
            If Not String.IsNullOrEmpty(Request.QueryString("club")) Then
                DDL_Club.Text = Request.QueryString("club")
            Else
                DDL_Club.Text = "ALL"
            End If
        End If
    End Sub

    Protected Sub DDL_Cat_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles DDL_Cat.PreRender
        If Not Page.IsPostBack Then
            If Not String.IsNullOrEmpty(Request.QueryString("cat")) Then
                DDL_Cat.Text = Request.QueryString("cat")
            Else
                DDL_Cat.Text = "ALL"
            End If
        End If
    End Sub
    Protected Sub Txt_Name_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Txt_Name.PreRender
        If Not Page.IsPostBack Then
            If Not String.IsNullOrEmpty(Request.QueryString("name")) Then
                Txt_Name.Text = Server.UrlDecode(Request.QueryString("name"))
            Else
                Txt_Name.Text = ""
            End If
        End If
    End Sub
    Protected Sub ApplyGridFilter()

    End Sub

    Protected Sub Grid_Results_DataBinding(ByVal sender As Object, ByVal e As System.EventArgs) Handles Grid_Results.DataBinding
        'Txt_ResultCount.Text = Grid_Results.Rows.Count.ToString
    End Sub
    Protected Sub Btn_Go_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Btn_Go.Click
        Dim newQryString As String = GetQueryString()
        Response.Redirect(GetNewURL(newQryString))
    End Sub
    Private Function GetClientIP() As String
        Dim ip As String = String.Empty
        ip = Request.UserHostAddress
        Return ip
    End Function
    Private Function GetNewURL(QryString As String) As String
        Dim newURL As String = Request.RawUrl
        ' remove any existing params
        If newURL.IndexOf("?") > 0 Then newURL = newURL.Substring(0, newURL.IndexOf("?"))
        newURL = "~" & newURL & QryString
        Return newURL
    End Function
    Private Function GetQueryString() As String
        Dim r As String = String.Empty
        r = "?race=" + Server.UrlEncode(rblRacePick.Text.ToUpper)
        If Not String.IsNullOrEmpty(DDL_Year.SelectedItem.Text) Then
            r += "&year=" + Server.UrlEncode(DDL_Year.SelectedItem.Text)
        End If
        If Not String.IsNullOrEmpty(DDL_Sex.SelectedItem.Text) Then
            r += "&sex=" + Server.UrlEncode(DDL_Sex.SelectedItem.Text)
        End If
        If Not String.IsNullOrEmpty(DDL_Club.SelectedItem.Text) Then
            r += "&club=" + Server.UrlEncode(DDL_Club.SelectedItem.Text)
        End If
        If Not String.IsNullOrEmpty(DDL_Cat.SelectedItem.Text) Then
            r += "&cat=" + Server.UrlEncode(DDL_Cat.SelectedItem.Text)
        End If
        If Not String.IsNullOrEmpty(Txt_Name.Text) Then
            r += "&name=" + Server.UrlEncode(Txt_Name.Text)
        End If
        Return r.Trim

    End Function
    Protected Sub Btn_ShowAll_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Btn_ShowAll.Click
        DDL_Year.SelectedIndex = 0
        DDL_Sex.SelectedIndex = 0
        DDL_Club.SelectedIndex = 0
        DDL_Cat.SelectedIndex = 0
        Txt_Name.Text = String.Empty
        'SaveCriteria()
        Response.Redirect(GetNewURL(GetQueryString()))
    End Sub


    Protected Sub Grid_Results_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles Grid_Results.DataBound
        Txt_ResultCount.Text = Grid_Results.Rows.Count.ToString
    End Sub

    Protected Sub rblRacePick_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles rblRacePick.SelectedIndexChanged
        Response.Redirect(GetNewURL(GetQueryString()))
    End Sub

</script>


 <asp:Panel ID="pnlWrapper" runat="server" CssClass="panelwrapper linksmodule">
 <portal:ModuleTitleControl id="Title1" runat="server" />

        <div style="padding: 0; margin: 0; width: 100%;">


        <table  class="filtercriteria" ><tr>
        <th style="width:16em;">
        Select which race to view:
        </th>
        <td>
        <asp:RadioButtonList ID="rblRacePick" runat="server" 
            AutoPostBack="True" RepeatDirection="Horizontal" 
                ToolTip="Select which race to view" >
            <asp:ListItem Selected="True">Pen y Fan</asp:ListItem>
            <asp:ListItem>Fan y Big Horseshoe</asp:ListItem>
        </asp:RadioButtonList>
        </td>
        </tr></table>

        <asp:Panel ID="Panel1" runat="server" DefaultButton="Btn_Go">
		
		<div style="overflow-x:auto;">
			<table class="filtercriteria" summary="filter criteria">
			<tr><th>Year</th><th>Sex</th><th>Club</th><th>Category</th><th>Name
				</th>
				<th>&nbsp;</th>
				<th>&nbsp;</th>
				<!-- <th>Count</th> -->
			</tr>
			<tr>
			<td>
			<asp:DropDownList ID="DDL_Year" runat="server" AppendDataBoundItems="False" 
					DataSourceID="SQLDataSource_Years" DataTextField="YearText" 
				DataValueField="YearValue" ToolTip="Select a year from the list" style="width:6em;margin-right:0.5em;">
			</asp:DropDownList>
			</td>
			<td>
			 <asp:DropDownList ID="DDL_Sex" runat="server" AppendDataBoundItems="False" DataTextField="Sex" 
				DataValueField="Sex" ToolTip="Select M or F" style="width:6em;margin-right:0.5em;">
				<asp:ListItem  Value="%" Selected="True">ALL</asp:ListItem>
				<asp:ListItem Selected="False">M</asp:ListItem>
				<asp:ListItem Selected="False">F</asp:ListItem>
			</asp:DropDownList>
			</td>
			<td>
			 <asp:DropDownList ID="DDL_Club" runat="server" AppendDataBoundItems="True" 
					DataSourceID="SQLDataSource_Clubs" DataTextField="Club" 
				DataValueField="Club" ToolTip="Select a club from the list" style="margin-right:0.5em;">
				<asp:ListItem Value="%" Selected="True">ALL</asp:ListItem>
			</asp:DropDownList>
			</td>
			<td>
			<asp:DropDownList ID="DDL_Cat" runat="server" AppendDataBoundItems="True" 
					DataSourceID="SQLDataSource_Cats" DataTextField="Cat" 
				DataValueField="Cat" ToolTip="Select a category from the list" style="width:6em;margin-right:0.5em;">
				<asp:ListItem Value="%" Selected="True">ALL</asp:ListItem>
			</asp:DropDownList>
			</td>
			<td>
				<asp:TextBox ID="Txt_Name" runat="server" 
					ToolTip="Enter all or part of a runner's name" style="width:8em;margin-right:0.5em;"></asp:TextBox>
			</td>
			<td>
					<asp:Button 
					ID="Btn_Go" runat="server" Text="GO" 
						ToolTip="Click to filter on these criteria"  style="margin-right:0.5em;"
						 />
			</td>
			<td>
				<asp:Button 
					ID="Btn_ShowAll" runat="server" Text="SHOW ALL" 
						ToolTip="Click to clear criteria and show all results" />
			</td>
			<%--
			<td>
					<asp:TextBox ID="Txt_ResultCount" runat="server"
						style="text-align:center;width:6em;" ToolTip="Number of results currently displayed"></asp:TextBox>
			</td>
			--%>
			</tr>
			</table>
		</div>
                </asp:Panel>
            <asp:SqlDataSource ID="SQLDataSource_Results" runat="server" ConnectionString="" 
                SelectCommand="SELECT [Year], [Name], [Club], [Cat], [SummitTime], [SummitPos], [DescentTime], [DescentPos], [FinishTime], [PosOverall], [PercentWinnerTime], [PosInCat], [Prize], [TeamPrize], [Sex],[Comment] FROM [bfr_ResultsForWeb] WHERE (([Year] LIKE @Year) AND ([Sex] LIKE @Sex) AND ([Club] LIKE @Club) AND ([Cat] LIKE @Cat) AND ([Name] LIKE '%' + @Name + '%') AND ([RaceName] LIKE @RaceName)) ORDER BY [PosOverall], [Year] DESC">
                <SelectParameters>
                     <asp:ControlParameter ControlID="DDL_Year" Name="Year" 
                        PropertyName="SelectedValue" />
                     <asp:ControlParameter ControlID="DDL_Sex" Name="Sex" 
                        PropertyName="SelectedValue" />
                     <asp:ControlParameter ControlID="DDL_Club" Name="Club" 
                        PropertyName="SelectedValue" />
                     <asp:ControlParameter ControlID="DDL_Cat" Name="Cat" 
                        PropertyName="SelectedValue" />
                     <asp:ControlParameter ControlID="Txt_Name" Name="Name" PropertyName="Text" 
                        Type="String"  DefaultValue="%" />
                     <asp:ControlParameter ControlID="rblRacePick" Name="RaceName" 
                        PropertyName="SelectedValue"   DefaultValue="Pen y Fan" />
                </SelectParameters>
            </asp:SqlDataSource>

        <asp:SqlDataSource ID="SQLDataSource_Years" runat="server" 
        SelectCommand="SELECT * FROM [bfr_RaceYearsForWeb] WHERE ([RaceName] LIKE @RaceName) ORDER BY YearText DESC">
            <SelectParameters>
                 <asp:ControlParameter ControlID="rblRacePick" Name="RaceName" 
                    PropertyName="Text" />
            </SelectParameters>
        </asp:SqlDataSource>

        <asp:SQLDataSource ID="SQLDataSource_Clubs" runat="server" 
        SelectCommand="SELECT Club FROM [bfr_Clubs] ORDER BY Club"></asp:SQLDataSource>
            
        <asp:SQLDataSource ID="SQLDataSource_Cats" runat="server" 
        SelectCommand="SELECT Cat FROM [bfr_Categories] ORDER BY Cat"></asp:SQLDataSource>

        <asp:AccessDataSource ID="AccessDataSource_Cats" runat="server"  
        SelectCommand="SELECT Cat FROM [bfr_Categories] WHERE [Cat] ORDER BY Cat"></asp:AccessDataSource>
<h2>Results &nbsp;(
<asp:TextBox ID="Txt_ResultCount" runat="server"
						style="text-align:center;width:6em;margin-left:1em;" ToolTip="Number of results currently displayed"></asp:TextBox>
						)
</h2>
		<!-- <div style="overflow-x:auto;width:100%;"> -->
		<div class="table-responsive">
        <asp:GridView ID="Grid_Results" cssclass="table table-striped" runat="server"  
            AllowSorting="True" AutoGenerateColumns="False" 
            DataSourceID="SQLDataSource_Results" ForeColor="#333333" 
            GridLines="None" 
            EmptyDataText="No results match those criteria!">
            <RowStyle BackColor="#EFF3FB" />
            <Columns>
                <asp:BoundField DataField="Year" HeaderText="Year" SortExpression="Year" />
                <asp:BoundField DataField="Name" HeaderText="Name" ReadOnly="True" 
                    SortExpression="Name" />
                <asp:BoundField DataField="Club" HeaderText="Club" SortExpression="Club" />
                <asp:BoundField DataField="Cat" HeaderText="Category" SortExpression="Cat" />
                <asp:BoundField DataField="SummitTime" HeaderText="Summit Time" ReadOnly="True" 
                    SortExpression="SummitTime" />
                <asp:BoundField DataField="SummitPos" HeaderText="Summit Pos" 
                    SortExpression="SummitPos" />
                <asp:BoundField DataField="DescentTime" HeaderText="Descent Time" 
                    ReadOnly="True" SortExpression="DescentTime" />
                <asp:BoundField DataField="DescentPos" HeaderText="Descent Pos" 
                    SortExpression="DescentPos" />
                <asp:BoundField DataField="FinishTime" HeaderText="Finish Time" ReadOnly="True" 
                    SortExpression="FinishTime" />
                <asp:BoundField DataField="PosOverall" HeaderText="Position" 
                    SortExpression="PosOverall" />
                <asp:BoundField DataField="PercentWinnerTime" HeaderText="% Win Time" 
                    SortExpression="PercentWinnerTime" />
                <asp:BoundField DataField="PosInCat" HeaderText="Pos In Cat" 
                    SortExpression="PosInCat" />
                <asp:BoundField DataField="Prize" HeaderText="Prize" SortExpression="Prize" />

            </Columns>
            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
            <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
            <HeaderStyle BackColor="#889dba" Font-Bold="True" ForeColor="White" />
            <EditRowStyle BackColor="#2461BF" />
            <AlternatingRowStyle BackColor="White" />
        </asp:GridView>
		</div>
        </div>

 </asp:Panel>



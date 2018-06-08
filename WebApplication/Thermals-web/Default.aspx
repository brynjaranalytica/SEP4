<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Thermals_web._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

<!-- Plotly chart will be drawn inside this DIV -->

<div id="graphDiv" style="height:700px"></div>

<script>
  (async function(){
 
  const json = await fetch('http://95.138.210.217/Thermal-forecast/Thermals-today.asmx/GetForecastJSON', {
  method: 'POST',
  headers: {
      'Accept': 'application/json,text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
      'Content-Type': 'application/x-www-form-urlencoded'
	  
    },})
	.then(res => res.json())
	.catch(console.log)
	;

  console.log(json);

	
  var json_result_cell_mid_lat = json.Cell_mid_lat;
  var json_result_cell_mid_long = json.Cell_mid_long;
  var json_result_strength = json.Strengths;
  var json_result_probability = json.Probabilites;
  var json_result_probability_with_text = [];
 
  json_result_probability.forEach(element => {
  json_result_probability_with_text.push("Probability: " + element);
  });
	
  //var scl = [[0,'rgb(5, 10, 172)'],[0.35,'rgb(40, 60, 190)'],[0.5,'rgb(70, 100, 245)'], [0.6,'rgb(90, 120, 245)'],[0.7,'rgb(106, 137, 247)'],[1,'rgb(220, 220, 220)']];
  var scl = [[0,'rgb(255, 0, 0)'],[0.35,'rgb(255, 111, 0)'],[0.5,'rgb(255, 182, 0)'], [0.6,'rgb(255, 234, 0)'],[0.7,'rgb(255, 243, 117)'],[1,'rgb(220, 220, 220)']];
  
  var myJson = 
{
  data: [
       {
         type: "scattermapbox",
		 text: json_result_probability_with_text,
         lat: 
					json_result_cell_mid_lat   
         , 
         lon: 
                   json_result_cell_mid_long 
         ,
         mode: "markers",
         marker: {
               "size":14,
			   color: json_result_strength,
			   opacity:0.8,
			   reversescale: true,
			   autocolorscale: false,
			   colorscale: scl,
			   cmin: 0,
			   colorbar: {
					title: 'Thermals Strength'
			   }
         }
    }
    ], 
    layout: {
       title: "Thermals Map",
       font: {
         color: "white"
       },
       dragmode: "zoom",
       mapbox: {
          center: {
               lat: 56.155535, 
               lon: 9.348318
          }, 
          domain: {
               x: [0, 1], 
               y: [0, 1]
           }, 
           style: "dark", 
           zoom: 8
       }, 
       margin: {
            r: 20, 
            t: 40, 
            b: 20, 
            l: 20, 
            pad: 0
        },
       paper_bgcolor: "#191A1A",
       plot_bgcolor: "#191A1A",
	   colorbar: true,
	   showland: true,
       landcolor: 'rgb(250,250,250)',
       subunitcolor: 'rgb(217,217,217)',
       countrycolor: 'rgb(217,217,217)',
       countrywidth: 0.5,
       subunitwidth: 0.5
       }
};

var figure = myJson;


Plotly.setPlotConfig({
    mapboxAccessToken: 'pk.eyJ1IjoiZXRwaW5hcmQiLCJhIjoiY2luMHIzdHE0MGFxNXVubTRxczZ2YmUxaCJ9.hwWZful0U2CQxit4ItNsiQ'
  });
 Plotly.plot('graphDiv',  figure.data, figure.layout);
})()
  </script>
</asp:Content>

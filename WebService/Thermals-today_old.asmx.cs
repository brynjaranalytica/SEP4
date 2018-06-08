
using Newtonsoft.Json;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;

namespace Thermal_forecast
{
    /// <summary>
    /// Summary description for Thermals_today
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class Thermals_today : System.Web.Services.WebService
    {

        private DateTime dateTime;
        private GridCellsDAO _data;

        public Thermals_today()
        {
            dateTime = DateTime.Now.Date;
            _data = MakeQuery();
        }
        private readonly string oradb = "Data Source=(DESCRIPTION ="
            + "(ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1522))"
            + "(CONNECT_DATA ="
            + "(SERVER = DEDICATED)"
            + "(SERVICE_NAME = sep4)    ) );"
            + "User Id=SEP4;Password=Horsens;";

        //[WebMethod]
        //public GridCellsDAO GetForecastXML()
        //{
        //    if (_data == null)
        //    {
        //        var _data = MakeQuery();
        //    }
        //    else
        //    {
        //        if (dateTime < DateTime.Now)
        //        {
        //            dateTime = DateTime.Now;
        //            _data = MakeQuery();
        //        }
        //    }

        //    return _data;
        //}

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public string GetForecastJSON()
        {
            if (_data == null)
            {
                var _data = MakeQuery();
            }
            else
            {
                if (dateTime < DateTime.Now)
                {
                    dateTime = DateTime.Now;
                    _data = MakeQuery();
                }
            }

            return new JavaScriptSerializer().Serialize(_data);
        }


        private GridCellsDAO MakeQuery()
        {
            List<double> latitudes = new List<double>();
            List<double> longitudes = new List<double>();
            List<double> strengths = new List<double>();
            List<double> probabilities = new List<double>();
            OracleConnection con = new OracleConnection(oradb);
            OracleCommand cmd = new OracleCommand();
            cmd.CommandText = "select latitude, longitude, thermal_strength as strength, thermal_probability as probability from thermal_analysis_exportable";
            cmd.Connection = con;
            con.Open();
            OracleDataReader dr = cmd.ExecuteReader();
            if (dr.HasRows)
            {
                while (dr.Read())
                {
                    latitudes.Add(dr.GetDouble(0));
                    longitudes.Add(dr.GetDouble(1));
                    strengths.Add(dr.GetDouble(2));
                    probabilities.Add(dr.GetDouble(3));
                }

            }

            con.Close();
            return new GridCellsDAO(latitudes, longitudes, strengths, probabilities); ;
        }
    }
}

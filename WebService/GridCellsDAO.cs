using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Thermal_forecast
{
    public class GridCellsDAO
    {
        public GridCellsDAO() :this (new List<double>(), new List<double>(), new List<double>(), new List<double>())
        {

        }
        public GridCellsDAO(List<double> latitudes, List<double> longitudes, List<double> strengths, List<double> probabilities)
        {
            Cell_mid_lat = latitudes;
            Cell_mid_long = longitudes;
            Strengths = strengths;
            Probabilites = probabilities;
        }
        public List<double> Cell_mid_lat { get; set; }
        public List<double> Cell_mid_long { get; set; }
        public List<double> Strengths { get; set; }
        public List<double> Probabilites { get; set; }
    }
}
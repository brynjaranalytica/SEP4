using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Thermal_forecast
{
    public class Data
    {
        public Data() : this(0, 0, 0, 0)
        {

        }
        public Data(double latitude, double longitude, double probability, double strength)
        {
            Latitude = latitude;
            Longitude = longitude;
            Probability = probability;
            Strength = strength;
        }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public double Probability { get; set; }
        public double Strength { get; set; }
    }
}
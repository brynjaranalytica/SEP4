
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map.Entry;

/**
 * @author Deyana, Alina
 *
 *         MapCellToAirport.java
 */

public class MapCellToAirport {
	// the credentials should be different when running on the server
	private static String jdbcURL = "jdbc:oracle:thin:@//localhost:1521/ORCL";
	private static String username = "SEP";
	private static String password = "SEP";

	public static Connection getConnection() throws SQLException {
		if (username == null) {
			return DriverManager.getConnection(jdbcURL);
		} else {
			DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
			return DriverManager.getConnection(jdbcURL, username, password);
		}
	}

	public static void mapCellsToAirport() {
		try {
			Connection c = getConnection();
			java.sql.Statement st = c.createStatement();
			st.execute("DELETE FROM ETL_GridCellToAirport");

			double cell_start_latitude, cell_end_latitude, cell_midpoint_latitude, cell_start_longitude,
					cell_end_longitude, cell_midpoint_longitude;

			PreparedStatement ps = c.prepareStatement(
					"select GRID_CELL_ID, START_LAT_AS_DECIMAL, START_LONG_AS_DECIMAL, END_LAT_AS_DECIMAL, END_LONG_AS_DECIMAL from D_GRIDCELL");
			ResultSet rs = ps.executeQuery();

			PreparedStatement ps3 = c.prepareStatement("INSERT INTO ETL_GridCellToAirport VALUES (?, ?)");

			HashMap<String, Coordinates> airports_coordinates = getAirportsCoordinates();

			HashMap<String, Double> distances_between_cell_and_airports = new HashMap<>();
			double distance_between_cell_and_airport;
			Entry<String, Double> min_distance_from_cell_to_airport;

			while (rs.next()) {
				// Get midpoint of the cell
				cell_start_latitude = rs.getDouble(2);
				cell_end_latitude = rs.getDouble(4);
				cell_midpoint_latitude = cell_start_latitude + ((cell_end_latitude - cell_start_latitude) / 2);

				cell_start_longitude = rs.getDouble(3);
				cell_end_longitude = rs.getDouble(5);
				cell_midpoint_longitude = cell_start_longitude + ((cell_end_longitude - cell_start_longitude) / 2);

				for (Entry<String, Coordinates> entry : airports_coordinates.entrySet()) {
					String airport = entry.getKey();
					Coordinates airport_coordinates = entry.getValue();

					// Calculate distance to each airport
					distance_between_cell_and_airport = Math
							.sqrt(Math.pow((cell_midpoint_latitude - airport_coordinates.getLatitude()), 2)
									+ Math.pow((cell_midpoint_longitude - airport_coordinates.getLongitude()), 2));
					distances_between_cell_and_airports.put(airport, distance_between_cell_and_airport);
				}

				// The airport that is closest is the one responsible for the cell
				// Which means the weather data from this station will be taken into
				// consideration when looking for thermals
				min_distance_from_cell_to_airport = null;
				for (Entry<String, Double> entry : distances_between_cell_and_airports.entrySet()) {
					if (min_distance_from_cell_to_airport == null
							|| min_distance_from_cell_to_airport.getValue() > entry.getValue()) {
						min_distance_from_cell_to_airport = entry;
					}
				}
				ps3.setInt(1, rs.getInt(1));
				ps3.setString(2, min_distance_from_cell_to_airport.getKey());
				ps3.execute();

			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static HashMap<String, Coordinates> getAirportsCoordinates() throws SQLException {
		Connection c = getConnection();
		PreparedStatement ps = c.prepareStatement("SELECT initials, latitude, longitude FROM weather_stations");

		HashMap<String, Coordinates> airport_coordinates = new HashMap<>();
		ResultSet rs1 = ps.executeQuery();
		Coordinates coordinates;

		while (rs1.next()) {
			coordinates = new Coordinates(rs1.getDouble(2), rs1.getDouble(3));
			airport_coordinates.put(rs1.getString(1), coordinates);
		}

		// for (Entry<String, Coordinates> entry : airport_coordinates.entrySet()) {
		// System.out.println("Airport: " + entry.getKey());
		// System.out.println("Latitude: " + entry.getValue().getLatitude());
		// System.out.println("Longitude: " + entry.getValue().getLongitude());
		// }
		return airport_coordinates;
	}

	public static void main(String[] args) {
		mapCellsToAirport();
	}
}

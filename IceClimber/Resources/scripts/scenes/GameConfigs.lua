require "AlignmentHelper"

gLocations = {
	{
		id = "mercury",
		image = "mercury.png",
		position = Coord(0.15, 0.5, 0, -87),
		opened = true,
		levels = {
			{
				opened = true,
				ccbFile = "Level1_1p1",
				tileMap = "Level1_2_map.tmx",
				cellSize = 32,
				tutorial = true
			},
			{
				opened = true,
				ccbFile = {"Level1_2p1", "Level1_2p2"},
				tileMap = "Level1_2_map.tmx",
				cellSize = 32,
				tutorial = false,
				time = 120
			},
			{
			},
			{

			},
			{

			},
			{

			}
		}
	},
	{
		id = "venus",
		image = "venus.png",
		position = Coord(0.32, 0.5, 0, -215)
	},
	{
		id = "earth",
		image = "earth.png",
		position = Coord(0.52, 0.5, 0, -235)
	},
	{
		id = "mars",
		image = "mars.png",
		position = Coord(0.78, 0.5, 0, -120)
	},
}
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
				ccbFile = "level_1_1",
				playerType = "PlayerObject"
			},
			{
				opened = true,
				ccbFile = "Level1_2p1",
				playerType = "FoxObject"
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
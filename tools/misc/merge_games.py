with open('ages.gbc', 'rb') as f:
    ages_data = f.read()


with open('seasons.gbc', 'rb') as f:
    seasons_data = f.read()


combined_games = bytearray(0x200*0x4000)
combined_games[:0x100*0x4000] = ages_data
combined_games[0x100*0x4000:] = seasons_data

with open('combined.gbc', 'wb') as f:
    f.write(combined_games)

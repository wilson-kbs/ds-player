import { ButtonBuilder, ButtonStyle } from 'discord.js';

export function playButton(playerId: string, disable = false) {
  return new ButtonBuilder()
    .setCustomId(`play:${playerId}`)
    .setStyle(ButtonStyle.Primary)
    .setLabel('▶')
    .setDisabled(disable);
}

export function pauseButton(playerId: string, disable = false) {
  return new ButtonBuilder()
    .setCustomId(`pause:${playerId}`)
    .setStyle(ButtonStyle.Success)
    .setLabel('⏸')
    .setDisabled(disable);
}

export function nextButton(playerId: string, disable = false) {
  return new ButtonBuilder()
    .setCustomId(`next:${playerId}`)
    .setStyle(ButtonStyle.Secondary)
    .setLabel('⏩')
    .setDisabled(disable);
}

export function previousButton(playerId: string, disable = false) {
  return new ButtonBuilder()
    .setCustomId(`previous:${playerId}`)
    .setStyle(ButtonStyle.Secondary)
    .setLabel('⏪')
    .setDisabled(disable);
}

export function stopButton(playerId: string, disable = false) {
  return new ButtonBuilder()
    .setCustomId(`stop:${playerId}`)
    .setStyle(ButtonStyle.Danger)
    .setLabel('⏹')
    .setDisabled(disable);
}

export function repeatButton(
  playerId: string,
  state?: 'none' | 'one' | 'all',
  disable = false,
) {
  switch (state) {
    case 'one':
      return new ButtonBuilder()
        .setCustomId(`repeat:${playerId}`)
        .setStyle(ButtonStyle.Success)
        .setLabel('🔂')
        .setDisabled(disable);
    case 'all':
      return new ButtonBuilder()
        .setCustomId(`repeat:${playerId}`)
        .setStyle(ButtonStyle.Primary)
        .setLabel('🔁')
        .setDisabled(disable);
    default:
      return new ButtonBuilder()
        .setCustomId(`repeat:${playerId}`)
        .setStyle(ButtonStyle.Secondary)
        .setLabel('🔁')
        .setDisabled(disable);
  }
}

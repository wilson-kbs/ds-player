import { SlashCommandBuilder } from '@discordjs/builders';

export function newStopCommandSchema() {
  return new SlashCommandBuilder()
    .setName('stop')
    .setDescription('Stop player');
}

export const StopCommandSchema = newStopCommandSchema();

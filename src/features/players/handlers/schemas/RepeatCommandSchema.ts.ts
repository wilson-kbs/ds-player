import { SlashCommandBuilder } from '@discordjs/builders';

function RepeatModeOptions(schema: SlashCommandBuilder) {
  schema.addStringOption((input) =>
    input
      .setName('mode')
      .setDescription('Choice repeat mode: all | one | none (default: none)')
      .setRequired(true)
      .addChoices(
        { name: 'all', value: 'all' },
        { name: 'one', value: 'one' },
        { name: 'none', value: 'none' },
      ),
  );
}

export function newRepeatCommandSchema() {
  const schema = new SlashCommandBuilder();
  schema.setName('repeat');
  schema.setDescription('Repeat mode');

  RepeatModeOptions(schema);

  return schema;
}

export const RepeatCommandSchema = newRepeatCommandSchema();

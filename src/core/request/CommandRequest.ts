import { ChatInputCommandInteraction } from 'discord.js';

import { IRequestBase } from '../abstract/IRequestBase';

export class CommandRequest extends IRequestBase<ChatInputCommandInteraction> {
  constructor(req: ChatInputCommandInteraction) {
    super(req);
  }

  get command() {
    return this.raw.commandName;
  }

  get subCommandGroup() {
    return this.raw.options.getSubcommandGroup(false);
  }

  get subCommand() {
    return this.raw.options.getSubcommand(false);
  }

  sendNotFound() {
    this.send('command not found').catch(console.warn);
  }
}

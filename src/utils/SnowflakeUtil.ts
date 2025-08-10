import { Snowflake } from '@sapphire/snowflake';

// Discord epoch: 2015-01-01T00:00:00.000Z
const snowflake = new Snowflake(1420070400000);

export const SnowflakeUtil = {
  generate(): string {
    return snowflake.generate().toString();
  },
};

export default SnowflakeUtil;

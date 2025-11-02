import { toNano } from '@ton/core';
import { UsersFactory } from '../build/UsersFactory/UsersFactory_UsersFactory';
import { NetworkProvider } from '@ton/blueprint';

export async function run(provider: NetworkProvider) {
    const sender = provider.sender();
    const usersFactory = provider.open(await UsersFactory.fromInit(sender.address!));

    await usersFactory.send(
        sender,
        {
            value: toNano('0.05'),
        },
        null,
    );

    await provider.waitForDeploy(usersFactory.address);

    // run methods on `usersFactory`
}

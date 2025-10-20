import { toNano } from '@ton/core';
import { User } from '../build/User/User_User';
import { NetworkProvider } from '@ton/blueprint';

export async function run(provider: NetworkProvider) {
    const user = provider.open(await User.fromInit());

    await user.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        null,
    );

    await provider.waitForDeploy(user.address);

    // run methods on `user`
}

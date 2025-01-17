<script>
    import { goto } from "$app/navigation";

    let inputUsername = $state();
    let inputPassword = $state();
    let showError = $state(false);
    let passwordElement = $state();
    let usernameElement = $state();

    //called if login decides that the username and password are valid
    async function successfulLogin(username) {
        const response = await fetch("/api/login", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ username: username }),
        });
        if (response.ok) {
            return true;
        } else {
            console.error(
                `ERROR: failed to create jwt or something, server responded with http code ${response.status}`,
            );
            return false;
        }
    }

    //this shits all fucked up ngl
    async function login() {
        const fetchOptions = {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                username: inputUsername,
                password: inputPassword,
            }),
        };

        //check if the user already exists
        const queryResponse = await fetch("/api/query-user", fetchOptions);
        if (queryResponse.ok) {
            const isSuccess = await successfulLogin(inputUsername);
            if (isSuccess) {
                goto("/home");
            }
            return;
        }

        if (queryResponse.status == 403) {
            console.log("ERROR: incorrect password");
            showError = true;
            usernameElement.classList.add('ring-2', 'ring-red-500');
            passwordElement.classList.add('ring-2', 'ring-red-500');
            return;
        }

        //if reponse from backend wasnt 200 or 403, then no user exists, thus create one
        const createResponse = await fetch("/api/create-user", fetchOptions);

        if (createResponse.status == 400) {
            console.error(
                "ERROR: server failed to create user, probably a taken username",
            );
            return;
        }
        if (createResponse.ok) {
            const isSuccess = await successfulLogin(inputUsername);
            if (isSuccess) {
                goto("/home");
            }
            return;
        }
    }
</script>

<div class="h-screen bg-gray-800">
    <div class="flex flex-col items-center">
        <div class="text-4xl mt-60 font-serif text-white">Login</div>

        <div class="mt-10">
            {#if showError}
                <div class="absolute text-red-500 ml-[90px]">Incorrect Password</div>
            {/if}
            <div class="mt-7">
                <form>
                    <input
                        type="text"
                        bind:value={inputUsername}
                        bind:this={usernameElement} 
                        placeholder="username"
                        class="text-xl ml-5 p-2 rounded-md bg-gray-400 placeholder:text-gray-800 text-black"
                    />
                </form>
                <form onsubmit={login}>
                    <input
                        type="password"
                        bind:value={inputPassword}
                        bind:this={passwordElement}
                        placeholder="password"
                        class="text-xl p-2 m-5 my-2 rounded-md bg-gray-400 placeholder:text-gray-800 text-black"
                    />
                </form>
                <div class="flex justify-center">
                    <button
                        onclick={login}
                        class="p-2 bg-blue-600 w-24 font-serif rounded-md text-xl hover:ring-2 hover:ring-blue-400 transition hover:shadow-md hover:shadow-black"
                        >Login</button
                    >
                </div>
            </div>
        </div>
    </div>
</div>

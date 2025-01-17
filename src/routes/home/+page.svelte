<script>
    /** @type {{ data: import('./$types').PageData }} */
    let { data, form } = $props();
    import Popup from "$lib/Popup.svelte";
    import ChatBar from "$lib/ChatBar.svelte";
    import SidePanel from "$lib/SidePanel.svelte";
    import { onMount } from "svelte";
    import { enhance } from "$app/forms";

    let newMessageState = $state(false);
    let toMessageUsername = $state("");
    let currentUser = $state(null);


    onMount(() => { 
        $effect(() => {
            if (form?.error) {
                console.log("error happened");
                document.getElementById("newMessageInput").classList.add("ring-2", "ring-red-600");
            }
        });
        currentUser = data.user;
    });

    async function logout() {
        await fetch('/api/logout');
        window.location.reload();
    }

</script>

<!-- this is the new message popup content, kind hard to see from the way its structered-->
{#snippet newMessage()}
    {#if form?.error}
        <div class="absolute text-sm text-red-600 ml-9 mt-20">ERROR: {form?.error}</div>
    {/if}
    <form method="POST" action="?/createChat" use:enhance>
        <input id="newMessageInput" type="text" name="username" placeholder="username" bind:value={toMessageUsername}
            class="p-2 text-md text-white bg-gray-700 mb-5 ml-7 rounded-md w-60">
        <button type="submit" class="bg-gray-700 p-2 ml-2 rounded-md text-md font-serif text-white hover:ring-2 hover:ring-blue-400 transition">Create Chat</button>
    </form>
    <div class="text-white text-xl ml-7 font-serif">Friends:</div> 
    <div class="text-white text-md ml-10 font-serif">either you have none or this feature doesnt exist yet </div>  
{/snippet}

<div class="w-screen h-screen absolute bg-gray-800 ">
    <div class="w-screen h-20 bg-gray-900 sticky flex items-center ring-1 ">
        <div class="text-white font-serif text-5xl ml-16">Disbord</div>
        <button onclick={logout} class="ml-auto bg-blue-600 p-2 text-lg font-serif m-5 rounded-md hover:ring-2 hover:ring-blue-300 transition w-24 mr-16">Logout</button>
    </div> 

    <div class="flex h-[83vh] mt-6">

        <div class="flex flex-col ">

            <div class="flex ml-14">
                <button onclick={() => { newMessageState = true; }} 
                    class="bg-blue-600 p-2 text-lg font-serif m-2 rounded-md hover:ring-2 hover:ring-blue-300 transition w-36">New Message</button>
            </div>

            <div class="ml-6 mt-4 overflow-y-auto overflow-x-hidden">
                <div class="text-white font-serif text-lg mb-1 ml-10">Your Chats:</div>
                {#if data?.chats[0]?.chatMembers && data.chats.length > 0 && currentUser}
                    {#each data.chats as chat}
                        <div class="my-1">
                            <ChatBar name={(chat.name == currentUser.username) ? (
                                    (chat.chatMembers[0] == currentUser.username) ? chat.chatMembers[1] : chat.chatMembers[0]) 
                                : chat.name} 
                            members={chat.chatMembers} currentUser={currentUser}/>
                        </div>
                    {/each}
                {/if}
            </div>
        </div>
        <SidePanel /> 

    </div>

    <div class="fixed bg-gray-900 w-screen bottom-0 ring-1 flex items-center">
       <a href="/delete-account" class="text-white text-4xl ml-3 p-2 rounded-2xl hover:bg-gray-500 transition-all">⚙</a> 
    </div>
    <Popup bind:state={ newMessageState } title="New Message" content={ newMessage }/>
    
</div>

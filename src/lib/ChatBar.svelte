
<script>
    let { name, members, currentUser } = $props();

    function deleteChat() {
        //TODO: add this functionality
    }
</script>

<a href="/home/{name}" class="flex ml-10 bg-gray-500 p-2 rounded-md hover:ring-2 hover:ring-blue-300 transition w-[59.5vw]">

    {#if currentUser?.username}
        {#if members.length > 2 }
            <div class="text-lg text-white font-serif w-40">{name}</div> 
            <div class="text-lg text-white font-serif ml-20 flex">
                <div>Members: </div>
                {#each members as member}
                    <div class="mx-2 font-bold">{member.username}</div> 
                {/each}
            </div>

        {:else}
            <div class="text-lg text-white font-serif w-40">
                {(members[0].username === currentUser?.username) ? members[1].username : members[0].username }
            </div>
        {/if}
    {:else}
        <div class="text-white font-serif text-xl">Loading</div>
    {/if}
    <button onclick={deleteChat} class="text-white text-2xl ml-auto mr-2">✕</button>

</a>
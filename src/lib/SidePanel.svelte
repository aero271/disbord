
<script>
    import { onMount } from "svelte";
    import UserBar from './UserBar.svelte';


    let users = $state([]);
    onMount(async () => {
        users = [
            { username: "person", bio: "im a person" },
            { username: "person", bio: "im a person" },
            { username: "person", bio: "im a person" },
            { username: "person", bio: "im a person" },
        ];
        
        

    });

</script>

<div class="bg-slate-900 w-[30vw] h-[75vh] ml-auto mr-16 rounded-lg">

    <div class="text-white font-serif text-4xl m-5">Discover</div>

    <div class="overflow-y-auto overflow-x-hidden">
        {#each users as user}
            <UserBar username={user.username} bio={user.bio}/> 
        {/each}
    </div>

</div>
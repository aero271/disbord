<script>
    import { onMount } from 'svelte';

    let { data } = $props();

    let element = $state();
    let pageState = $state(false);

    onMount(() => {
        setTimeout(() => {
            pageState = true;
        }, 1000 * 2)
    })


</script>

<div class="bg-gray-800 h-screen w-screen absolute">
    {#if !pageState}
        <div class="flex flex-col justify-center items-center h-3/4 mt-60 w-3/4">
            <div class="text-white text-7xl font-serif">Rendering Page</div>
            <div class="text-white text-2xl font-serif mb-5">This might take a while</div>
        </div> 
    {:else}
        <div>
            
        </div>
    {/if}
</div>

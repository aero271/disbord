
<script>
    import { onMount } from "svelte";

    let { state = $bindable(), content, title } = $props();

    function unhide() {
        const popup = document.getElementById("popup");
        popup.classList.remove("scale-0");
        
    }

    function hide() {
        state = false;
        const popup = document.getElementById("popup");
        popup.classList.add("scale-0");
    }

    onMount(() => {
        $effect(() => {
            if (state) {
                unhide();
            }
            else {
                hide();
            }
        });
    });

</script>

<div id="popup" class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 scale-0 transition-all">
    <div class="bg-gray-900 w-[30rem] h-[30rem] rounded-lg flex flex-col">
        <div class="flex m-6">
            <div class="text-white font-serif text-3xl">{title}</div>
            <button onclick={hide} class="text-3xl font-bold ml-auto text-white">✕</button>
        </div>
        {@render content()}
    </div>
</div>
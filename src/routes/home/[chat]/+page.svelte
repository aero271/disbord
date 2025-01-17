<script>
    import { page } from "$app/stores";
    import { onDestroy, onMount, tick } from "svelte";

    /** @type {{ data: import('./$types').PageData }} */
    let { data } = $props();
    
    let name = $derived($page.params.chat);
    let messages = $state([]);
    let ws;
    let input = $state("")
    let messageContainer = $state();
    let messageElement = $state();

    //automatically scroll to most recent messages
    $effect(async () => {
        if (messages.length) {
            await tick();
            messageContainer?.scrollTo({
                top: messageContainer.scrollHeight,
                behaviour: 'smooth',
            });
        }
    });

    //sort messages by time each time its updated
    $effect(() => {
        if (messages) {
            messages.sort((a, b) => a.time_sent - b.time_sent);
        }
    })

    onMount(async () => {

        messages = data.messages;
        ws = new WebSocket("wss://chatapp.servehalflife.com/messages");

        //send an initial message to the websocket to tell it what chat it is, idk why its in a timeout i forgot
        ws.onopen = () => {
            ws.send(JSON.stringify({
                chatId: data.chatData.chatId,
                message: null,
            }));
        }

        //appends received message to messages
        ws.onmessage = (data) => {
            const message = JSON.parse(data.data);
            messages = [...messages, message];
        }
        ws.onerror = (error) => { console.error(`Websocket error: ${error}`); };

    });

    onDestroy(() => {
        if (ws?.readyState == 1) {
            ws.close();
        }
    })

    function sendMessage(event) {
        event.preventDefault();
        if (input === '') return;

        //adds the sent message to database
        fetch('/api/send-message', {
            method: 'POST',
            headers: { 'ContentType': 'application/json', },
            body: JSON.stringify({
                chatData: data.chatData,
                message: input,
            })
        })
        .then((response) => {
            if (!response.ok) {
                console.error('ERROR: Failed to store message');
            }
        })
        .catch((error) => { console.error('ERROR: Storing message fetch failed with: ', error); });

        //sends message to websocket for real time chatting, no reload needed
        const time = new Date();
        const messageData = JSON.stringify({
            chatId: data.chatData.chatId,
            message: {
                content: input,
                username: data.user.username,
                time_sent: time
            }
        });
        ws.send(messageData);

        //resets input to nothing and focuses on the form again
        input = '';
        messageElement.focus();
    }

</script>


<div class="w-screen h-screen bg-gray-800 ">
    <div class="w-screen h-20 bg-gray-900 sticky">
        <div class="flex ">
            <a href="/home" class="text-white text-7xl mx-10">←</a>
        </div>
    </div>
    <div class="text-white text-7xl font-serif m-10 ml-20">{name}</div>

    <div bind:this={messageContainer} class="ml-20 w-[85vw] h-[60vh] overflow-y-auto overflow-x-hidden">
        {#each messages as message}
            <div class="flex text-gray-400 font-serif">
                <div class="mx-5">{message.username}</div>
                <div>{message.time_sent}</div>
            </div>
            <div class="ml-5 text-white font-serif text-lg">{message.content}</div>
        {/each}
    </div>

    <div class="flex fixed bottom-0">
        <form class="m-20" onsubmit={sendMessage}>
            <input name="message" type="text" placeholder="Message {name}" bind:value={input} bind:this={messageElement} autocomplete="off"
            class="bg-gray-900 text-white text-lg rounded-md p-2 w-[75vw]">
            <button type="submit" class="bg-gray-900 text-white text-lg rounded-xl p-2 w-12">↑</button>
        </form>
    </div>
    
</div>

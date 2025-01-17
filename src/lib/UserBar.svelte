
<script>
    let { username, bio } = $props();

</script>

<div class="flex w-[28vw] bg-gray-500 h-12 rounded lg mb-1 ml-4 items-center text-white font-serif text-lg">
    <div class="w-32 ml-2">{username}</div>
    <div>Bio: {bio}</div>
    <button class="ml-auto ring-2 ring-blue-600 rounded-lg p-1 mr-2 hover:bg-blue-600 hover:text-gray-800 transition-all px-4">Add Friend</button>
</div>
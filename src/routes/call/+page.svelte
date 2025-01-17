<script>
    import { onMount, onDestroy } from 'svelte';
    let ws;
    let audioContext;
    const sampleRate = 16000;

    onMount(() => {
        ws = new WebSocket('wss://chatapp.servehalflife.com/ws');
        ws.binaryType = 'arraybuffer';

        ws.onopen = () => {
            console.log('connected to server');
        }

        ws.onmessage = async (receivedMessage) => {
            console.log("reseived data");
            
            if(!audioContext)   {
                audioContext = new AudioContext({ sampleRate });
            }

            const int16Data = new Int16Array(receivedMessage.data);
            const float32Data = int16ToFloat32(int16Data);
            console.log("float data: ", float32Data);
            
            const buffer = audioContext.createBuffer(1, float32Data.length, sampleRate);
            buffer.copyToChannel(float32Data, 0, 0);

            const source = audioContext.createBufferSource();
            source.buffer = buffer;
            source.connect(audioContext.destination);
            source.start();
        }

        ws.onerror = (error) => {
            console.log('websocket error: ', error);
        }

        ws.onclose = () => {
            console.log('connection closed');
        }

    });
    function float32ToInt16(buffer) {  
        let l = buffer.length;
        let buf = new Int16Array(l);
        while (l--) {
            buf[l] = Math.min(1, buffer[l]) * 0x7FFF;
        }
        return buf;
    }

    function int16ToFloat32(input) {
        let float32 = new Float32Array(input.length);
        for (let i = 0; i < input.length; i++) {
            float32[i] = input[i] / 0x7FFF;
        }
        return float32;
    }

    function connectToCall() {
        const audioContraints = { audio: true };

        navigator.mediaDevices.getUserMedia(audioContraints).then(stream => {
            
            const sampleRate= 16000;
            if (!audioContext) {
                audioContext = new AudioContext({ sampleRate });
            }
            const source = audioContext.createMediaStreamSource(stream);

            const processor = audioContext.createScriptProcessor(4096, 1, 1);

            source.connect(processor);
            processor.connect(audioContext.destination);

            processor.onaudioprocess = (audioEvent) => {
                const audioData = audioEvent.inputBuffer.getChannelData(0);
                const encodedData = float32ToInt16(audioData);
                ws.send(encodedData.buffer);
            }

        }).catch(error => {
            console.error("error accessing microphone: ", error);
        });
    }

</script>

<button onclick={connectToCall} class="fixed left-1/2 -translate-x-1/2 px-6 py-3 top-2 bg-gray-900 text-white rounded-lg">connect</button>
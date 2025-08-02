#!/bin/bash

# Performance monitoring script for Boundless Prover
# Run this to track your performance and optimize for leaderboard ranking

echo "🚀 Boundless Prover Performance Monitor"
echo "========================================"

# Check GPU utilization
echo "📊 GPU Utilization:"
nvidia-smi --query-gpu=index,name,utilization.gpu,memory.used,memory.total,temperature.gpu --format=csv,noheader,nounits | while IFS=, read -r index name util mem_used mem_total temp; do
    echo "GPU $index ($name): ${util}% | Memory: ${mem_used}MB/${mem_total}MB | Temp: ${temp}°C"
done

echo ""

# Check Docker containers
echo "🐳 Docker Containers Status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "(broker|agent|bento)"

echo ""

# Check broker logs for recent activity
echo "📝 Recent Broker Activity (last 10 lines):"
docker logs --tail 10 boundless-broker-1 2>/dev/null | grep -E "(Locking|Primary|Order|Proof)" || echo "No recent activity found"

echo ""

# Check system resources
echo "💻 System Resources:"
echo "CPU Usage: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)%"
echo "Memory Usage: $(free | grep Mem | awk '{printf "%.1f%%", $3/$2 * 100.0}')"
echo "Disk Usage: $(df / | tail -1 | awk '{print $5}')"

echo ""

# Check network connectivity
echo "🌐 Network Status:"
ping -c 1 8.8.8.8 >/dev/null 2>&1 && echo "Internet: ✅ Connected" || echo "Internet: ❌ Disconnected"
ping -c 1 1.1.1.1 >/dev/null 2>&1 && echo "DNS: ✅ Working" || echo "DNS: ❌ Issues"

echo ""

# Performance tips
echo "💡 Performance Tips:"
echo "1. Monitor GPU utilization - should be >80% for optimal performance"
echo "2. Check broker logs for 'Locking' messages - indicates primary order acquisition"
echo "3. Ensure all 8 GPU agents are running: docker ps | grep agent"
echo "4. Monitor stake balance to avoid overcommitment"
echo "5. Check leaderboard at: https://signal.beboundless.xyz/prove/leaderboard"

echo ""

# Auto-refresh every 30 seconds
echo "🔄 Auto-refreshing every 30 seconds... (Ctrl+C to stop)"
sleep 30
exec "$0" 
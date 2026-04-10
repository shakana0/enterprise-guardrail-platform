using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace EnterpriseGuardrailPlatform.Functions;

public class QueueProcessor
{
    private readonly ILogger _logger;

    public QueueProcessor(ILoggerFactory loggerFactory)
    {
        _logger = loggerFactory.CreateLogger<QueueProcessor>();
    }

    [Function("QueueProcessor")]
    public void Run(
        [ServiceBusTrigger("demo-queue", Connection = "ServiceBusConnection")]
        string message)
    {
        _logger.LogInformation($"Received message: {message}");
    }
}

| **Title** | **Resilient AWS Architecture Implementation** |
|----|----|
| **Description** | **Deliver a highly available, fault tolerant and seamlessly scalable architecture to accommodate varying levels of traffic.** |

**Solution & Components:**

**VPC:**

consisting of an internet gateway, 3 availability zones (az), 3 public
subnets 1 per az, 3 private subnets 1 per az for the application logic
tier and 3 private subnets 1 per az for DB tier altogether 3 public
subnets and 6 private subnets.

- The public subnets each host Nat gateways to provide external access
  for devices in the private subnets that require it.

- The private subnets (application logic tier) host an ec2 autoscaling
  group fronted by an application load balancer (ALB).

- The private subnet (DB tier) hosting an Aurora MySQL RDS cluster
  across the 3 az.

- The RDS cluster is fronted by an Amazon ElastiCache for Redis
  replication group with a subnet group that spans all 3 DB tier
  subnets.

- The DB tier subnets also serve as mount targets for an Amazon Elastic
  File System.

**Amazon CloudFront Distribution:**

Pointing to the ALB as an origin and leveraging S3 for content/media
storage, is used to cache and serve content closer to user in so doing
reducing latency and offload traffic from the origin and application
servers.

Ec2 Instances in an AutoScaling Group:

EC2 instances running Apache, PhP and WorPress along with other
necessary plugins Sql and Redis clients.

**Amazon Aurora (MySQL):**

Provides RDBM functionality for the solution, its high-performance
distributed architecture provides enhances resilience and fault
tolerance, ensuring continuous availability and data durability.

**an Amazon ElastiCache (REDIS):**

Will optimizes application performance by caching frequently accessed
data from Aurora cluster in memory. It will reduce latency, improves
scalability by offloading database read operations, and ensures high
availability with automatic cluster scaling.

**Amazon Elastic FileSystem (EFS):**

To provide a scalable and highly available file storage solution that
will enable data sharing and collaboration across the solution’s
infrastructure and ensures data consistency and durability, with
automatic scalability to accommodate growing storage needs**.**

**Amazon CloudWatch:**

Used to monitor, collect and track metrics related to CPU usage of the
autoscaling group. CloudWatch is configured with alarms based on
predefined thresholds for CPU utilization to ensure proactive monitoring
of resource usage. When the alarm threshold is breached an autoscaling
event is triggered.

CloudWatch will also be used to create log groups for ElastiCache
component of the solution**.**

**KMS KEYS:**

Keys to encrypt ElasticCache data at rest in the Redis cluster nodes and
log data for the ElastiCache CloudWatch log groups.

**AWS Systems Manager:**

Used manages instance profiles for EC2 instances, configures Amazon EFS
mount points, and securely distributes credentials for accessing the
Amazon S3 bucket containing media content. SSM Parameter Store also
holds the ElastiCache endpoint and port number**.**

**AWS Secrets Manager Secret:**

To store the AUTH token used to secure cached data in transit form
ElastiCache**.**
